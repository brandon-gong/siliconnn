#include <time.h>
#include "dataset.h"

/**
 * Set the random seed to system time. Otherwise, rand() will act like srand(1)
 * was called, and nothing will change between runs.
 * Seeding the randomizer is necessary for both ds_shuffle and nn_init.
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

	// Cleanup all memory
	ds_destroy(&tr);
	ds_destroy(&te);
	ds_deep_destroy(&ds);
}
