#ifndef _DATASET_H_
#define _DATASET_H_

#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <math.h>
#include "util.h"

/**
 * Defines a single labeled example that can be used in training or testing.
 * The label must be a single integer value (multiple labels not supported),
 * and the example attributes are expected to be doubles.
 */
typedef struct data {

	// The label corresponding to this particular example. Critically, GCC
  // pads the 4 byte int to 8 bytes, and we will need to be careful to either
  // replicate this in asm or adjust our loading code to not do the alignment
	int label;

	// The array of attributes corresponding to this particular example.
	double* example;

} data;

/**
 * A `dataset` is an array of examples. We store an array of pointers to
 * examples instead to greatly facilitate shuffling and splitting datasets;
 * we can keep the underlying data in memory the same, and the `dataset` is
 * simply a view of a subset of the underlying data.
 * 
 * We also store how many examples there are in this particular dataset, and
 * how many attributes there are per example.
 * 
 * The _mmap_ptr field is used to keep track of the beginning of the underlying
 * data in memory, so it can be freed later.
 */
typedef struct dataset {
	// Array of examples in this dataset.
	data **examples;
	// Total number of examples in this dataset.
	int num_examples;
	// Number of attributes per example in this dataset.
	int num_attributes;
	// The pointer returned by mmap, for management purposes
	data *_mmap_ptr;
} dataset;

/**
 * Destroy a `dataset` (freeing its `examples` list back to the OS), but
 * preserves the underlying data. Use this when you have multiple datasets over
 * the same block of underlying data.
 * 
 * @param ds a pointer to the dataset to destroy.
 */
void ds_destroy(dataset *ds);

/**
 * Destroy a `dataset`, freeing everything - including the underlying data -
 * back to the OS. If you have multiple datasets over the same block of data,
 * calling ds_deep_destroy will invalidate all of them. This function
 * automatically calls ds_destroy to cleanup the `examples` list as well.
 * 
 * @param ds a pointer to the dataset to deeply destroy.
 */
void ds_deep_destroy(dataset *ds);

/**
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
 * @param filepath the path to the CSV file to parse and load into a dataset.
 * @param numrows the number of rows in the dataset, counting the header row
 * @param numcols the number of columns in the dataset, counting the labels
 * 	column
 * @param ds the uninitialized ds struct to initialize and load the data into.
 */
void ds_load(char *filepath, int numrows, int numcols, dataset *ds);

/**
 * Shuffle a dataset in place, changing the order of its examples, using
 * Fisher-Yates.
 * 
 * @param ds the dataset to shuffle.
 */
void ds_shuffle(dataset *ds);

/**
 * Split a dataset into training and testing sets. This does not shuffle the
 * dataset beforehand, please do it manually first with ds_shuffle if desired.
 * 
 * @param original the dataset to split into training and testing sets
 * @param train_set a pointer to an uninitialized dataset, to be filled with
 * 	training examples
 * @param test_set a pointer to an uninitialized dataset, to be filled with
 * 	testing examples
 * @param test_ratio The proportion of the original set to turn into testing
 * 	examples.
 */
void ds_train_test_split(dataset *original, dataset *train_set,
	dataset *test_set, double test_ratio);

/**
 * Prints a dataset to the terminal, for debugging purposes.
 * @param ds the dataset to print.
 */
void ds_show(dataset *ds);

/**
 * Normalizes all attributes in the dataset to have mean of 0 and standard
 * deviation of 1. This generally boosts accuracy as no particular attribute
 * gets weighted unfairly.
 */ 
void ds_normalize(dataset *ds);

#endif
