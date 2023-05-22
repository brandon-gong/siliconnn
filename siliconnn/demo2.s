/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/demo2.c
 *
 * Demo 2: Loading Iris CSV dataset, training on network, and saving to file
 * "demo.nn".
 */

.global _main
.align 2

// We reserve stack space for one dataset and one net. Memory layout:
// [SP + 0]: Stores the return address (old value of link register)
// [SP + 24]: Stores the dataset
// [SP + 64]: Stores the neural network
_main:
	SUB SP, SP, #96              // Allocate stack space, per above
	STR LR, [SP]                 // Store return address into [SP + 0]

	BL _seed                     // Seed the random number generator

	// Just like demo1, we load the data from a CSV file located at data_path by
	// using ds_load.
	ADR X0, data_path            // First argument: pointer to path of CSV file
	MOV X1, #151                 // Second argument: this CSV file has 151 rows
	MOV X2, #5                   // Third argument: this CSV file has 5 columns
	ADD X3, SP, #8               // Fourth argument: space allocated for dataset
	BL _ds_load                  // Load the iris dataset from CSV file into ds

	// Also like demo1, we initialize and train the network.
	ADD X0, SP, #32              // First argument to nn_init: ptr to space for nn
	MOV X1, #4                   // Second argument: only 4 input neurons this time
	MOV X2, #2                   // Third argument: 2 hidden neurons
	LDR D0, learning_rate        // Fourth argument: learning rate of 0.05
	BL _nn_init                  // Initialize the network with the given specs

	ADD X0, SP, #32              // First arg to nn_train: ptr to intialized net
	ADD X1, SP, #8               // Second argument: ptr to loaded dataset
	MOV X2, #25                  // Third argument: train for 25 epochs
	BL _nn_train                 // Train the network

	// Now, instead of testing it immediately, we'll just dump the network to a
	// .nn file. In demo3, we'll load this pretrained network back out of the file
	// and demonstrate that its functionality is preserved.
	ADD X0, SP, #32              // First argument to nn_save: pointer to network
	ADR X1, save_path            // Second argument: path to save file at
	BL _nn_save                  // Save the pretrained net to demo.nn

	// We are done here; cleanup
	ADD X0, SP, #32              // First argument to nn_destroy: pointer to net
	BL _nn_destroy               // Destroy resources allocated for the network

	ADD X0, SP, #8               // First argument to ds_deep_destroy: ptr to ds
	BL _ds_deep_destroy          // Deeply destroy the dataset

	// Exit
	MOV X0, #0                   // We will exit with normal status (0)
	LDR LR, [SP]                 // Reload return address back into link register
	ADD SP, SP, #96              // Deallocate stack space
	RET                          // return 0;

learning_rate:  .quad 0.05
data_path:      .asciz "../test_sets/iris.csv"
.align 2
save_path:      .asciz "demo.nn"
