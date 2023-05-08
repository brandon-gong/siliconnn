#include "dataset.h"

extern void consume_past_char(char **ptr, char *end, char c);
extern int parse_int(char **ptr);
extern double parse_double(char **ptr);
extern void parse_data(char **ptr, data *d, int num_attributes, char *end);

/*
 * Just need to munmap the `examples` part of the struct, since we don't want
 * to free the underlying data in this case.
 */
// void Cds_destroy(dataset *ds) {
// 	// total size of arrray is number of examples * the size of a pointer
// 	int err = munmap(ds->examples, ds->num_examples * sizeof(data*));
// 	if(err) {
// 		perror("ds_destroy munmap");
// 		exit(8);
// 	}
// }

/*
 * To ds_deep_destroy, just need to munmap the saved `_mmap_ptr` and then call
 * ds_destroy to handle the rest.
 */
// void Cds_deep_destroy(dataset *ds) {
// 	// Compute the size of the block. This is duplicate code from loading,
// 	// TODO does it make sense to restructure this?
// 	size_t data_size = sizeof(int) + ds->num_attributes * sizeof(double);
// 	size_t block_size = ds->num_examples * data_size;

// 	// Free the underlying data
// 	int err = munmap(ds->_mmap_ptr, block_size);
// 	if(err) {
// 		perror("ds_deep_destroy munmap");
// 		exit(9);
// 	}

// 	// Free ds->examples
// 	ds_destroy(ds);
// }

/*
 * In our CSV parser we frequently find ourselves needing to throw away parts
 * of the input, e.g. when we want to skip the header row, or we've finished
 * parsing a number and want to skip past the comma or newline. This function
 * moves the pointer through the CSV string data until its past the char c we
 * specify.
 *
 * @param ptr the ptr to move
 * @param end the rightmost limit of ptr; this is a stop condition in case there
 * 	are no more of c to consume. Without this, we may sigfault
 * @param c the character to consume past.
 */
// void C_consume_past_char(char **ptr, char *end, char c) {
// 	while(**ptr != c) {
// 		(*ptr)++;
// 		if (*ptr == end) return;
// 	}
// 	(*ptr)++;
// }

/*
 * Helper function to parse an int. Also moves the ptr past the int so it is
 * pointing at the next character which is not part of the int.
 */
// int C_parse_int(char **ptr) {
// 	// the result
// 	int r = 0;

// 	// the sign of the result
// 	int sgn = 1;

// 	// we only check the sign on the first character; a sign anywhere else is
// 	// considered invalid
// 	if (**ptr == '-') {
// 		sgn = -1;
// 		(*ptr)++;
// 	}

// 	// While we keep seeing digits, append them to our result, and keep
// 	// updating ptr
// 	while (**ptr >= '0' && **ptr <= '9') {
// 		r = r * 10 + (**ptr - '0');
// 		(*ptr)++;
// 	}

// 	// We've hit some character that is not part of the number (e.g. comma),
// 	// so stop incrementing ptr and return r with the right sign.
// 	return sgn*r;
// }

/*
 * Helper function to parse a float. Some similar ideas to int, except we also
 * keep track of the exponent. This doesn't support scientific notation, but
 * is otherwise somewhat durable; "-.3", "-00.0001", "091.100" all successfully
 * parse
 */
// double C_parse_double(char **ptr) {
// 	double r = 0.0;
// 	int sgn = 1;

// 	// A flag telling us whether or not we've seen a decimal point yet.
// 	int is_exp = 0;
// 	// In the end, we will divide r by 10^exp.
// 	int exp = 0;

// 	if (**ptr == '-') {
// 		sgn = -1;
// 		(*ptr)++;
// 	}

// 	// Loop until we encounter some invalid character. TODO I'm realizing this
// 	// (and the parse_int function) could have issues if the CSV files don't end
// 	// with a newline.
// 	while(1) {
// 		if (**ptr == '.') {
// 			// We can only have one decimal point, second one is not part of the
// 			// number, so break
// 			if (is_exp) break;
// 			else is_exp = 1;
// 		} else if (**ptr >= '0' && **ptr <= '9') {
// 			// similar logic to before but also keep track of the exponent
// 			r = r * 10 + (**ptr - '0');
// 			exp += is_exp;
// 		} else {
// 			// Unrecognized character
// 			break;
// 		}

// 		// Move ptr along
// 		(*ptr)++;
// 	}
// 	// Scale r back down to the correct value. Using this while loop avoids any
// 	// cmath shenanigans
// 	while(exp--) r /= 10.0;
// 	return sgn*r;
// }

/*
 * Parse a row of the CSV file into the given `data` struct, moving ptr to the
 * beginning of the next row.
 */
// void C_parse_data(char **ptr, data *d, int num_attributes, char *end) {
// 	// Consume the label first
// 	d->label = parse_int(ptr);
// 	d->example = (double*) ((long) d + sizeof(data));

// 	// Parse all of the attributes in this row
// 	for(int i = 0; i < num_attributes; i++) {
// 		consume_past_char(ptr, end, ',');
// 		d->example[i] = parse_double(ptr);
// 	}

// 	// Move ptr to next row
// 	consume_past_char(ptr, end, '\n');
// }

/*
 * Loads a CSV file. The file MUST have a header row, the first column
 * MUST be labels (integers only).
 */
void Cds_load(char *filepath, int numrows, int numcols, dataset *ds) {
	// e.g. load_csv("iris.csv", 151, 5, &ds);
	// need to mmap() 3 things:
	// - underlying data[]
	// - the data[] for this particular dataset
	// - the file we read from (munmapped before the return of this function)

	ds->num_examples = numrows - 1;
	ds->num_attributes = numcols - 1;

	// Allocate space for the underlying data. This is a pretty big allocation,
	// but we only have to do it once; train-test-split reuses underlying data
	// without moving anything.

	// We first compute the total size we need to allocate
	size_t data_size = sizeof(data) + ds->num_attributes * sizeof(double);
	size_t block_size = ds->num_examples * data_size;

	// key flag is MAP_ANONYMOUS, and we need RW access
	data *data_ptr = mmap(NULL, block_size, PROT_READ | PROT_WRITE,
		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
	if(data_ptr == MAP_FAILED) {
		printf("data_ptr map failed\n");
		exit(10);
	}
	// Save this ptr returned from mmap for freeing later
	ds->_mmap_ptr = data_ptr;

	// We now open the CSV file for reading. just need read access for this
	int fd = open(filepath, O_RDONLY);
	if(fd < 0){
		perror("open");
		exit(11);
	}
	// Need to obtain the size of the file for mmap
	struct stat statbuf;
	int err = fstat(fd, &statbuf);
	if(err < 0){
		perror("fstat");
		exit(12);
	}
	// CSV files may be quite large, so instead of `read` onto the stack into
	// a huge buffer or something, much simpler to mmap into it
	char *file_ptr = mmap(NULL, statbuf.st_size, PROT_READ, MAP_SHARED, fd, 0);
	if(file_ptr == MAP_FAILED) {
		printf("file_ptr map failed\n");
		exit(13);
	}
	close(fd);

	// mmap one more time for ds->examples.
	ds->examples = mmap(NULL, sizeof(data*) * ds->num_examples,
		PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
	if(ds->examples == MAP_FAILED) {
		printf("ds->examples map failed\n");
		exit(14);
	}

	// file_ptr was returned by mmap and points to the first char in the file.
	// end is the end of the file, computed by start + size
	char *parse_ptr = file_ptr;
	char *end = file_ptr + statbuf.st_size;

	// skip first line
	consume_past_char(&parse_ptr, end, '\n');
	// Parse row-by-row into underlying memory, and also save each index into
	// ds->examples
	for (int i = 0; i < ds->num_examples; i++) {
		data *d = (data*) ((long) data_ptr + i * data_size);
		ds->examples[i] = d;
		parse_data(&parse_ptr, d, ds->num_attributes, end);
	}

	// We are done using the file, so we can unmap it
	err = munmap(file_ptr, statbuf.st_size);
	if(err) {
		perror("munmap");
		exit(15);
	}
}

// This is a very trivial and direct usage of Fisher-Yates, since all we are
// doing is moving pointers around, and not touching the underlying data at all
void Cds_shuffle(dataset *ds) {
	int i, j;
	data *tmp;
	for (i = ds->num_examples - 1; i > 0; i--) {
		j = rand() % (i + 1);
		tmp = ds->examples[j];
		ds->examples[j] = ds->examples[i];
		ds->examples[i] = tmp;
	}
}

// This function uses two mmaps, one for each of train_set and test_set.
// Most of the other work is just initializing the various fields of train_set
// and test_set
void Cds_train_test_split(
	dataset *original,
	dataset *train_set,
	dataset *test_set,
	double test_ratio) {

	// Clamp test_ratio to [0, 1].
	if (test_ratio < 0) test_ratio = 0;
	if (test_ratio > 1) test_ratio = 1;

	// Compute number of examples in each set
	int test_size = (int) (test_ratio * original->num_examples);
	int train_size = original->num_examples - test_size;

	// Initialize all of the fields of both structs to something reasonable
	test_set->num_examples = test_size;
	train_set->num_examples = train_size;
	test_set->num_attributes = original->num_attributes;
	train_set->num_attributes = original->num_attributes;
	// It doesn't really make sense to set it to original's _mmap_ptr, because
	// it doesn't make sense to deep delete these sets. We can't recover the
	// total number of pages to unmap from the data in these structs.
	// TODO not really sure what to do here.
	test_set->_mmap_ptr = NULL;
	train_set->_mmap_ptr = NULL;

	test_set->examples = mmap(NULL, sizeof(data*) * test_size,
		PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
	train_set->examples = mmap(NULL, sizeof(data*) * train_size,
		PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
	
	// Just copy the first n examples into the test set, and the remaining
	// examples into the train set.
	for(int i = 0; i < test_size; i++) {
		test_set->examples[i] = original->examples[i];
	}
	for(int i = test_size; i < original->num_examples; i++) {
		train_set->examples[i - test_size] = original->examples[i];
	}
}

void Cds_show(dataset *ds) {
	char buf[32];
	int sz;

	// Also print out row numbers, helpful for making sure we are getting the
	// number of examples in the set that we expect
	for(int i = 0; i < ds->num_examples; i++) {
		// Print the row number and label
		sz = Citoa(buf, i);
		write(STDOUT_FILENO, buf, sz);
		write(STDOUT_FILENO, " | ", 3);
		sz = Citoa(buf, ds->examples[i]->label);
		write(STDOUT_FILENO, buf, sz);
		// print all the attrs for the example
		for(int j = 0; j < ds->num_attributes; j++) {
			write(STDOUT_FILENO, ",", 1);
			sz = Cdtoa(buf,  ds->examples[i]->example[j], 2);
			write(STDOUT_FILENO, buf, sz);
		}
		write(STDOUT_FILENO, "\n", 1);
	}
}

void Cds_normalize(dataset *ds) {
	// We iterate over attributes, finding mean and std. Have to go in three passes.
	for(int i = 0; i < ds->num_attributes; i++) {
		// First pass: compute the mean. mean = total / num_examples
		double mean = 0;
		for(int j = 0; j < ds->num_examples; j++) {
			mean += ds->examples[j]->example[i];
		}
		mean /= ds->num_examples;

		// Second pass: compute std. Std = sqrt(sum of squared differences / num_examples)
		double std = 0;
		for(int j = 0; j < ds->num_examples; j++) {
			double diff = ds->examples[j]->example[i] - mean;
			std += diff * diff;
		}
		std /= ds->num_examples;
		std = sqrt(std);

		// Third pass: rescale all attributes with mean and std
		for(int j = 0; j < ds->num_examples; j++) {
			ds->examples[j]->example[i] = (ds->examples[j]->example[i] - mean) / std;
		}
	}
}
