/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/demo1.c
 *
 * Demo 1: Loading Wine CSV dataset, demonstrate dataset train-test-split and
 * printing functionality, training on network, and printing test loss.
 */

.global _main
.align 2

// These demo files are not _short_, per se, but you will notice that they
// contain no logic at all, and just demonstrate the abilities of siliconnn.
// Most of the code here is just setting up for and making calls to siliconnn
// functions.
// For demo1, we need a decent amount of stack space for 3 datasets, 1 network,
// and 1 buffer (for printing test accuracy). The layout is as follows:
// [SP + 0]: Stores the return address for this function
// [SP + 8] - [SP + 32]: allocated space for the dataset loaded from file
// [SP + 32] - [SP + 56]: allocated space for training data-sub-set
// [SP + 56] - [SP + 80]: allocated space for testing data subset
// [SP + 80] - [SP + 144]: allocated space for the neural network
// [SP + 144] - [SP + 176]: allocated space for the buffer used by dtoa
_main:
	SUB SP, SP, #176            // Allocate space on stack per above
	STR LR, [SP]                // Save correct return address from link register

	BL _seed                    // Seed the random number generator

	// First thing we do is load the CSV file at data_path into a dataset struct.
	// This single function call handles opening/parsing the CSV file, allocating
	// space, and setting up the ds struct.
	ADR X0, data_path           // First argument to ds_load: path to CSV file
	MOV X1, #179                // Second argument: the CSV file has 179 rows
	MOV X2, #14                 // Third argument: the CSV file has 14 columns
	ADD X3, SP, #8              // Fourth argument: pointer to [SP + 8]
	BL _ds_load                 // Load the CSV file into ds struct at [SP + 8]

	// The raw data may have disproportionately scaled features, which may cause
	// worse training results as some features get weighted far more than others.
	// To fix this, we normalize all features to have mean 0, standard deviation
	// 1; siliconnn provides this functionality with ds_normalize.
	ADD X0, SP, #8              // First argument to ds_normalize: pointer to ds
	BL _ds_normalize            // Normalize the dataset we just loaded.

	// Now we want to split the dataset into train and test sets. Before we do so,
	// though, we shuffle the dataset, in case the CSV file's data came sorted in
	// some way.
	ADD X0, SP, #8              // First argument to ds_shuffle: pointer to ds
	BL _ds_shuffle              // Shuffle the dataset.

	// Now we proceed with train-test-split.
	ADD X0, SP, #8              // First argument: ptr to dataset we are splitting
	ADD X1, SP, #32             // Second argument: ptr to space for train set
	ADD X2, SP, #56             // Third argument: ptr to space for test set
	LDR D0, test_size           // Fourth argument: use 20% of data for test set
	BL _ds_train_test_split     // Split loaded dataset into train and test sets.

	// To show train-test-split is functioning properly, we will now print out
	// both datasets to stdout.

	// This prints the string "----------TRAIN SET-----------" out to stdout,
	// as kind of a visual "header" for the user to see we are about to print
	// the train set.
	MOV X0, #1                  // First argument to write: STDOUT_FILENO
	ADR X1, train_set           // Second argument: location of string (see below)
	MOV X2, #32                 // Third argument: the string is 32 chars long
	BL _write                   // Print out TRAIN SET header

	// Now we actually print out the training set itself; this functionality is
	// provided by ds_show.
	ADD X0, SP, #32             // First argument to ds_show: ptr to train set
	BL _ds_show                 // Print the train set out to stdout.

	// Similarly, we want to print the string "----------TEST SET-----------",
	// to mark that the next printed info is part of the test set.
	MOV X0, #1                  // First argument to write: STDOUT_FILENO
	ADR X1, test_set            // Second argument: location of string
	MOV X2, #31                 // Third argument: the string is 31 chars long
	BL _write                   // Print out TEST SET header

	// Now we actually print out the test set.
	ADD X0, SP, #56             // First argument to ds_show: ptr to test set
	BL _ds_show                 // Print the test set out to stdout.

	// We are done initializing our datasets; now, we will train a network on
	// the training set and then check its ability to generalize to unseen data
	// by evaluating its average loss on the training set.

	// First though, we need to initialize the network, with nn_init. This takes
	// care of setting up all fields of the struct, initializing space for weights
	// and biases, and setting those weights and biases to random initial values.
	ADD X0, SP, #80             // First argument to nn_init: ptr to space for net
	MOV X1, #13                 // Second argument: net will have 13 input neurons
	MOV X2, #18                 // Third argument: net will have 18 hidden neurons
	LDR D0, learning_rate       // Fourth argument: learning rate of 0.01
	BL _nn_init                 // Initialize the network with the given specs

	// We will now train the network on the training set for 100 epochs.
	ADD X0, SP, #80             // First argument to nn_train: ptr to the network
	ADD X1, SP, #32             // Second argument: pointer to training dataset
	MOV X2, #100                // Third argument: we want to train for 100 epochs
	BL _nn_train                // Train the net on training set for 100 epochs

	// We now want to compute and display the loss on the held-out test set to
	// the user. For clarity, we print a little label "Avg test loss:" before we
	// print the actual loss. The below write call takes care of this.
	MOV X0, #1                  // First argument to write: STDOUT_FILENO
	ADR X1, avg_loss            // Second argument: location of string to print
	MOV X2, #15                 // Third argument: we want to print 15 chars
	BL _write                   // Print out the label to stdout

	// Below, we actually compute the average loss on the test set. The resulting
	// loss gets stored in register D0.
	ADD X0, SP, #80             // First argument to nn_average_loss: ptr to net
	ADD X1, SP, #56             // Second argument: pointer to held-out test set
	BL _nn_average_loss         // Get the average loss over the test set in D0

	// We need to convert this floating point value to a sequence of base-10
	// characters that we can print out to stdout, and dtoa handles this. The
	// second argument to dtoa, the floating point value itself, is already in
	// in the right place in D0. We just need to set up the first and third args.
	ADD X0, SP, #144            // First argument to dtoa: buffer space
	MOV X1, #10                 // Second argument: 10 decimal places of precision
	BL _dtoa                    // Convert D0 to a stringified representation

	// We can now print out the average test loss.
	MOV X2, X0                  // Third arg to write: length of stringified loss
	MOV X0, #1                  // First argument: STDOUT_FILENO
	ADD X1, SP, #144            // Second argument: the buffer that dtoa updated
	BL _write                   // Print the average test loss.

	// Now we are actually done with all of the things we wanted the demo to
	// show; last thing to do is to cleanup the network and three datasets.

	// Destroy the network, deallocating the space reserved for its weights and
	// biases.
	ADD X0, SP, #80             // First argument to nn_destroy: ptr to the net
	BL _nn_destroy              // Destroy the net

	// Destory the train set
	ADD X0, SP, #32             // First argument to ds_destroy: ptr to train set
	BL _ds_destroy              // Destroy the train set

	// Destroy the test set
	ADD X0, SP, #56             // First argument to ds_destroy: ptr to test set
	BL _ds_destroy              // Destroy the test set

	// Deeply destroy the dataset. Aside from destroying the dataset, it also
	// deallocates all space initially reserved by ds_load when we loaded the CSV
	// file.
	ADD X0, SP, #8              // First argument to ds_deep_destroy: ptr to ds
	BL _ds_deep_destroy         // Deeply destroy the whole dataset

	// Completely done; exit
	MOV X0, #0                  // We exit with normal status (0)
	LDR LR, [SP]                // Load return address back into link register
	ADD SP, SP, #176            // Deallocate stack space used by main
	RET                         // return 0;

// Below are just useful constants used by main, including some of the strings
// we are printing and the path to the file to load.

// Note we reserve test_size and learning_rate here just for convenience; we
// cannot directly do FMOV D0, #0.2, because FMOV is very limited in the
// floating-point immediates that it can load. We would have to MOV the IEEE754
// representation of the double into a general-purpose register first, then
// FMOV it to a floating-point register. This is a pain and less readable than
// just initializing it below.
test_size:      .quad 0.2
learning_rate:  .quad 0.01
// .asciz differs from .ascii by null-terminating the string.
data_path:      .asciz "../test_sets/wine.csv"
.align 2
avg_loss:       .ascii "Avg test loss: "
.align 2
train_set:      .ascii "\n----------TRAIN SET-----------\n"
test_set:       .ascii "\n----------TEST SET-----------\n"
