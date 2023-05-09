/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/dataset.c#L157
 *
 * Load a dataset from a CSV file. Since I'm not about to implement a full-blown
 * CSV parser in assembly, there are some following limitations:
 * - There MUST be a header row in the table. (It doesn't matter whats in it,
 *   it is ignored)
 * - The label column MUST be first.
 * - Labels are expected to be integers, everything else is expected to be
 *   floating point numbers (no scientific notation).
 * - No spaces or quotes anywhere.
 * - Comma is the only accepted delimiter.
 * - File must be in LF format, CRLF will cause issues
 * 
 * @param X0 pointer to the path of CSV file to parse and load into a dataset.
 * @param X1 the number of rows in the dataset, counting the header row
 * @param X2 the number of columns in the dataset, counting the labels
 * 	column
 * @param X3 pointer to the uninitialized ds struct to initialize and load.
 * Returns nothing.
 */

.global _ds_load
.align 2

// This is the first real behemoth of a function I implemented, there is nothing
// really difficult here going on algorithmically but we need to be careful
// with how we use the memory.
// This is the basic layout of our stack memory:
// [SP] LR
// [SP + 8] *ds
// [SP + 16] fd
// [SP + 24] struct stat
// [SP + 24] st_size        ** We overwrite everything from fstat except st_size
// [SP + 32] file_ptr
// [SP + 40] parse_ptr
// [SP + 48] end
// [SP + 56] i
// [SP + 64] data_size
// struct stat starts at SP + 24, and it has size 144UL. Thus we need to move
// the stack pointer 24+144=168 bytes; in reality we move it 176 bytes to keep
// it 16-byte aligned
_ds_load:
	SUB SP, SP, #176               // Allocate space on stack per above
	STP LR, X3, [SP]               // Store LR in [SP], *ds in [SP + 8]
	SUB W1, W1, #1                 // num_examples = numrows - 1
	SUB W2, W2, #1                 // num_attributes = numcols - 1
	STP W1, W2, [X3, #8]           // ds->num_examples = W1, ds->num_attrs = W2

	// Opening the user's CSV file for reading.
	// First argument, the path to the CSV file, is already in X0, so we just need
	// to set up the second argument to open(), namely the flags
	MOV X1, #0                     // We are opening the file in O_RDONLY mode
	BL _open                       // open(filepath, O_RDONLY)
	CMP X0, #0                     // fd < 0?
	B.LT err_open                  // if so, exit with correct err code
	STR X0, [SP, #16]              // Otherwise store fd in stack as specified

	// Again, happily we have the first argument to fstat (fd) already in place,
	// so we just need to set up the second argumnet
	ADD X1, SP, 24                 // Pointer to [SP + 24], our `struct stat`

	// After this below system call to fstat, a bunch of stuff will be populated
	// in our stack memory, from [SP+24] to [SP + 168]. We only really care
	// about st_size, which is at a 96-byte offset from the start of the struct,
	// so a 24+96=120 byte offset from SP.
	BL _fstat
	CMP X0, #0                     // Check error message from fstat
	B.LT err_fstat                 // if error, exit with proper code

	LDR X1, [SP, #120]             // Again, we only care about st_size = X1
	STR X1, [SP, #24]              // Re-store st_size at [SP, #24]

	// We will now treat SP+32 onwards as unused memory and will write over
	// the rest of the useless info returned by fstat. Note it was critical that
	// we called fstat first, otherwise fstat will clobber whatever we set up
	// in the following lines.

	LDR X3, [SP, #8]                // Re-load ds pointer into X3
	LDP W1, W2, [X3, #8]            // Get num_examples, num_attrs out of ds

	// Computing data_size and block_size in C ref impl
	LSL X2, X2, #3                  // X2 = (num_attrs) * sizeof(double)
	ADD X2, X2, #16                 // X2 += sizeof(data)
	STR X2, [SP, #64]               // Store X2 (data_size) as specified
	MUL X1, X1, X2                  // block_size = data_size * num_examples

	// Setting up for data_ptr mmap call
	MOV X0, #0                      // First argument: NULL
	MOV X2, #0x3                    // PROT_READ | PROT_WRITE (need rw access)
	MOV X3, #0x1001                 // MAP_SHARED | MAP_ANONYMOUS (not actual file)
	MOV X4, #-1                     // fd = -1 since we aren't mapping a file
	MOV X5, #0                      // no offset
	BL _mmap                        // call mmap

	CMP X0, #0                      // mmap returns MAP_FAILED = -1 on error
	B.LT err_data_mmap              // if error, exit with correct code
	LDR X3, [SP, #8]                // Reload X3 = ds
	STR X0, [X3, #16]               // store return addr from mmap into ds->_mmap_ptr

	// Going straight into next mmap call, this time for mmaping the file itself
	MOV X0, #0                      // First argument is again null
	LDR X1, [SP, #24]               // map size is file size; we stored it earlier
	MOV X2, 0x01                    // PROT_READ
	MOV X3, 0x01                    // MAP_SHARED
	LDR X4, [SP, #16]               // fd is the file we opened earlier
	MOV X5, #0                      // again no offset
	BL _mmap                        // call mmap

	CMP X0, #0                      // same as previous; check for MAP_FAILED
	B.LT err_file_mmap              // ..and exit if it did fail

	// We store the successfully mmap-ed pointer to the beginning of the file for
	// later munmapping purposes
	STR X0, [SP, #32]

	LDR X0, [SP, #16]               // We are done with the file now, we close it
	BL _close                       // with close(fd)

	// There is one more mmap to be done. To review, we've mmap-ed a giant block
	// of space to store all of the CSV data, and mmap-ed the file for reading.
	// Now, we mmap space for the examples[] data* array which will contain
	// pointers to the big block that we mmmap-ed first.

	// This extra layer of abstraction allows us to split and shuffle data easily,
	// since instead of having to rearrange the actual underlying data, we just
	// move some pointers around on top of the data.
	LDR X1, [SP, #8]                // Preparing second argument; X1 = ds
	LDR W1, [X1, #8]                // W1 = ds->num_examples (load only first 4 bytes)
	LSL X1, X1, #3                  // W1 *= sizeof(data*) = W1 * 2^3
	MOV X0, #0                      // Begin setting up mmap for third time: NULL
	MOV X2, #0x3                    // PROT_READ | PROT_WRITE
	MOV X3, #0x1001                 // MAP_SHARED | MAP_ANONYMOUS
	MOV X4, #-1                     // fd = -1
	MOV X5, #0                      // offset = 0
	BL _mmap                        // call mmap

	CMP X0, #0                      // Error checking mmap
	B.LT err_examples_mmap          // exit with code if error

	LDR X1, [SP, #8]                // Else mmap was successful, so we
	STR X0, [X1]                    // store the returned ptr in ds->examples

	// We are done allocating space for stuff and making system calls for now,
	// now we need to set up for parsing.
	LDR X0, [SP, #32]               // Get the file_ptr we mmaped earlier,
	STR X0, [SP, #40]               // and copy that same address to SP + 40.
	// The reason why we just did that is because we need to modify SP + 40 to
	// keep track of where we are in the parse, but also want to keep the original
	// address so we can munmap it later. So we won't touch SP + 32 again until
	// the end.

	// Computing *end, the rightmost limit of the mmap and the end of the file.
	// Reading past *end means a probable segfault.
	LDR X2, [SP, #24]               // Get st_size again,
	ADD X1, X0, X2                  // and compute *end with it.

	// Setting up for consume_past_char call (this one for discarding the header
	// row). We've already got X1 being *end, just need to set up X0 and X2
	MOV X2, #10                     // X2 = '\n'
	ADD X0, SP, #40                 // X0 = the literal address of char* in stack
	BL _consume_past_char           // consume_past_char(char** ptr, end, '\n')

	// Here is the forloop for parsing the remaining CSV data row-by-row.
	MOV X0, #0
for:
	// Condition check
	LDR X1, [SP, #8]            // X1 = ds
	LDR W1, [X1, #8]            // W1 = ds->num_examples
	CMP W0, W1                  // i < ds->num_examples?
	B.GE endloop                // if not, break
	
	// Computing location in the big memory block (we mmap-ed earlier) for the
	// next `data` struct, based on i
	LDR X1, [SP, #8]            // X1 = ds
	LDR X1, [X1, #16]           // X1 = ds->_mmap_ptr
	LDR X2, [SP, #64]           // X2 = data_size
	MUL X2, X2, X0              // X2 = i * data_size
	ADD X1, X1, X2              // X1 = ds->_mmap_ptr + i * data_size

	// Computing location in the smaller memory block (examples[]) to store
	// the data* we just computed
	LDR X2, [SP, #8]            // X2 = ds
	MOV X4, X0                  // X4 = i
	LSL X4, X4, #3              // X4 *= 8
	LDR X5, [X2]                // X5 = examples
	ADD X5, X5, X4              // X5 = X5 + i*8

	// Store the data* in the correct slot in the examples array
	STR X1, [X5]                // ds->examples[i] = d

	// Save i on the stack setup for parse_data call
	STR X0, [SP, #56]           // store i in stack
	ADD X0, SP, #40             // X0 = &parse_ptr
	LDR W2, [X2, #12]           // X2 = ds->num_attributes
	LDR X3, [SP, #48]           // X3 = end
	BL _parse_data              // parse_data(&parse_ptr, num_attrs, end)

	LDR X0, [SP, #56]           // Get i back out of the stack,
	ADD X0, X0, #1              // i++,
	B for                       // and go back to checking the condition.

// At this point we've parsed num_examples rows of data, fully populated our
// mmap-ed data blocks. Last thing to do: we are done with the mmap we did
// for our CSV file, so we munmap it.
// The other two mmaps, i.e. the big memory mmap and the smaller examples mmap,
// have their corresponding munmaps in ds_deep_destroy and ds_destroy,
// respectively.
endloop:
	LDR X0, [SP, #32]           // Setup for munmap: first arg is the saved file_ptr
	LDR X1, [SP, #24]           // Second arg is st_size
	BL _munmap                  // munmap(file_ptr, st_size)
	CBNZ X0, err_munmap         // if nonzero return, error happened

	LDR LR, [SP]                // Load the correct return address
	ADD SP, SP, #176            // deallocate stack space
	RET                         // return

// The below labels are only reached in the case of some system call failure,
// and their only job is to call exit() with their corresponding unique nonzero
// exit code. Not much comment is required.
err_open:
	MOV X0, #11
	B _exit                      // exit(11)

err_data_mmap:
	MOV X0, #10
	B _exit                      // exit(10)

err_fstat:
	MOV X0, #12
	B _exit                      // exit(12)

err_file_mmap:
	MOV X0, #13
	B _exit                      // exit(13)

err_examples_mmap:
	MOV X0, #14
	B _exit                      // exit(14)

err_munmap:
	MOV X0, #15
	B _exit                      // exit(15)
