/*
 * This is the C reference implementation that will be transcribed to Assembly
 * by hand. In order to make this work, we have to make sure that every stdlib
 * call we make (functions we use that are included by #include <...>) is backed
 * by either a straight arm64 instruction, or is a system call.
 *
 * Particularly of note, we don't have access to malloc. We get by this quite
 * easily by using mmap instead; while mmap is potentially slower, it doesn't
 * really matter for us, since we only need to allocate memory for ourselves
 * a few times for loading the training data and making space for weights.
 * All in all, mmap is called about 6-7 times total for initialization,
 * training, and running, which is really not that much.
 * 
 * The code is also written to avoid recursion and avoid returning structs or
 * anything complicated like that. However, it otherwise is decent quality;
 * we don't skip over things like memory cleanup.
 */

#include <time.h>
#include "dataset.h"
#include "nn.h"

/**
 * Set the random seed to system time. Otherwise, rand() will act like srand(1)
 * was called, and nothing will change between runs.
 * Seeding the randomizer is necessary for both ds_shuffle and nn_init.
 * In the assembly implementation, we won't be using C library functions for
 * random, and will have to rely on something like RNDR.
 */
void seed() {
	struct timespec t;
	// we have to do this instead of just time(NULL)
	// because clock_gettime is a syscall and time is stdlib
	if(clock_gettime(CLOCK_REALTIME, &t) == -1) {
		perror("clock_gettime");
		exit(1);
	}
	// Seed the randomizer with system time
	srand(t.tv_sec);
}

// amazingly ds is done
// now all thats left to do is nn
int main(int argc, char **argv) {
	seed();

	// Load a dataset from the CSV and shuffle it so everything is randomized
	dataset ds;
	ds_load("../test_sets/iris.csv", 151, 5, &ds);
	ds_shuffle(&ds);

	// Split the dataset into training and testing sets, with testing set being
	// 20% the size of the original corpus, and training being the 80%.
	dataset tr, te;
	ds_train_test_split(&ds, &tr, &te, 0.2);
	
	// Print everything out to make sure everything looks ok
	printf("\n----------TRAIN SET-----------\n");
	ds_show(&tr);

	printf("\n----------TEST SET-----------\n");
	ds_show(&te);

	nn neti, netf;
	nn_init(&neti, 4, 8, 0.012);
	nn_train(&neti, &tr, 25);

	// for(int i = 0; i < te.num_examples; i++) {
	// 	printf("%f\n", );
	// }

	printf("----------------------------\n");
	nn_save(&neti, "test.nn");
	//nn_destroy(&neti);

	nn_load(&netf, "test.nn");
	for(int i = 0; i < te.num_examples; i++) {
		printf("%f - %f\n", nn_forward(&neti, te.examples[i]->example), nn_forward(&netf, te.examples[i]->example));
	}

	printf("\n%f | %f\n", neti.b1[2], netf.b1[2]);

	// Cleanup all memory
	ds_destroy(&tr);
	ds_destroy(&te);
	ds_deep_destroy(&ds);
	nn_destroy(&netf);
}
