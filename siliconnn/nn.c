#include "nn.h"

// old friend sigmoid
double C_sigmoid(double x) {
	return 1.0 / (1.0 + exp(-x));
}

// This formula is used fairly often throughout, so just decided to pull it into
// a helper function. It is derived by
// |w01| + |b1| + |o1| + |w12|
// = input_size * hidden_size + hidden_size + hidden_size + hidden_size
// = hidden_size * (input_size + 1 + 1 + 1)
// = hidden_size * (input_size + 3)
// and then we multiply the result by sizeof(double) to get the total memory
// requirement in bytes (for mmap)
size_t C_compute_mem_reqs(int input_size, int hidden_size) {
	return sizeof(double) * hidden_size * (input_size + 3);
}

// Zero out all of the outputs in the network before each forward pass
void C_zero_outputs(nn *net) {
	net->o2 = 0.0;
	for(int i = 0; i < net->hidden_size; i++) {
		net->o1[i] = 0.0;
	}
}

// Helper fn to generate a random double between 0 and 1. I don't know if this
// is uniformly distributed, but if it isn't, I'm not about to implement a
// uniformly distributed RNG
double C_random_01() {
	return ((double) rand() / RAND_MAX);
}

// Helper function called by nn_init to randomize all of the weights of a
// network. Necessary to establish independence between all of the neurons
void C_random_weights(nn *net) {
	for(int i = 0; i < net->hidden_size; i++) {
		for(int j = 0; j < net->input_size; j++) {
			net->w01[j * net->hidden_size + i] = C_random_01();
		}
		net->b1[i] = C_random_01();
		net->w12[i] = C_random_01();
	}
	net->b2 = C_random_01();
}

/*
 * This function has to take care of setting all of the appropriate fields of
 * the net struct to correct values, mmap-ing the required space needed for the
 * weights and biases, and initializing everything to expected values
 * (randomizing the weights and biases, zeroing out activations)
 */
void Cnn_init(nn *net, int input_size, int hidden_size, double learning_rate) {
	net->input_size = input_size;
	net->hidden_size = hidden_size;
	net->learning_rate = learning_rate;
	int mem_size = C_compute_mem_reqs(input_size, hidden_size);
	// mmap the required space. w01 will point to the beginning of the block,
	// but keep in mind that its not the whole block, just the first input*hidden
	// slots
	net->w01 = mmap(NULL, mem_size, PROT_READ | PROT_WRITE,
		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
	if(net->w01 == MAP_FAILED) {
		printf("nn_init map failed\n");
		exit(1);
	}
	// set up the other pointers into the block
	net->b1 = net->w01 + input_size * hidden_size;
	net->o1 = net->b1 + hidden_size;
	net->w12 = net->o1 + hidden_size;
	// initialize everything
	C_zero_outputs(net);
	C_random_weights(net);
}

// Very simple, just deallocate the pages starting at w01
void Cnn_destroy(nn *net) {
	int mem_size = C_compute_mem_reqs(net->input_size, net->hidden_size);
	int err = munmap(net->w01, mem_size);
	if(err) {
		perror("nn_destroy munmap");
		exit(2);
	}
}

// Compute a forward pass through the network, pretty much how you would expect.
double Cnn_forward(nn *net, double *x) {
	C_zero_outputs(net);
	for(int i = 0; i < net->input_size; i++) {
		for(int j = 0; j < net->hidden_size; j++) {
			net->o1[j] += x[i] * net->w01[i*net->hidden_size + j];
		}
	}
	for(int i = 0; i < net->hidden_size; i++) {
		net->o1[i] = C_sigmoid(net->o1[i] + net->b1[i]);
	}
	for(int i = 0; i < net->hidden_size; i++) {
		net->o2 += net->o1[i] * net->w12[i];
	}
	net->o2 += net->b2;
	return net->o2;
}

/*
 * This is where things get a little gnarly, especially because we have to work
 * around not having a linalg library handy, and I also don't want to deal with
 * allocating extra space for temporary variables. For reference, here are the
 * math formulas I derived. It is almost directly translated into the code;
 * updating everything in this order allows us to do the whole thing in-place
 * iteratively.
 *
 * grad_b2 = 2 * (o2 - y)
 * grad_w12_i = 2 * (o2 - y) * o1_i
 * grad_b1_i = 2 * (o2 - y) * w12_i * o1_i * (1 - o1_i) (sigmoid derivative here)
 * grad_w01_ji = 2 * (o2 - y) * w12_i * o1_i * (1 - o1_i) * x_i
 */
void Cnn_backward(nn *net, double *x, int y) {
	// update b2
	double grad_b2 = 2 * (net->o2 - y);
	net->b2 -= net->learning_rate * grad_b2;

	// update everything else
	for(int i = 0; i < net->hidden_size; i++) {
		double grad_w12_i = grad_b2 * net->o1[i];
		double grad_b1_i = grad_b2 * net->w12[i] * net->o1[i] * (1 - net->o1[i]);
		net->w12[i] -= net->learning_rate * grad_w12_i;
		net->b1[i] -= net->learning_rate * grad_b1_i;
		for(int j = 0; j < net->input_size; j++) {
			double grad_w01_ji = x[j] * grad_b1_i;
			net->w01[j*net->hidden_size + i] -= net->learning_rate * grad_w01_ji;
		}
	}
}

// Pretty much straight up the formula. Accumulate the squared error in
// total_loss and divide by num_examples at the end to get avg loss
double Cnn_average_loss(nn *net, dataset *ds) {
	double total_loss = 0;
	for(int i = 0; i < ds->num_examples; i++) {
		double pred = Cnn_forward(net, ds->examples[i]->example);
		double err = ds->examples[i]->label - pred;
		total_loss += err*err;
	}
	return total_loss / ds->num_examples;
}

// For each epoch, do forward and backward pass with all the examples in the
// training set, and then log useful data to the terminal. Then shuffle the
// data and go to the next epoch.
void Cnn_train(nn *net, dataset *ds, int num_epochs) {
	// These two variables are just for logging (see next few lines)
	char buf[32];
	int sz;

	for(int i = 0; i < num_epochs; i++) {
		for(int j = 0; j < ds->num_examples; j++) {
			Cnn_forward(net, ds->examples[j]->example);
			Cnn_backward(net, ds->examples[j]->example, ds->examples[j]->label);
		}

		// We have to do this convoluted stuff with write because we don't have
		// printf in the asm world
		double loss = Cnn_average_loss(net, ds);
		write(STDOUT_FILENO, "Epoch ", 6);
		sz = Citoa(buf, i);
		write(STDOUT_FILENO, buf, sz);
		write(STDOUT_FILENO, " | Loss: ", 9);
		sz = Cdtoa(buf, loss, 10);
		write(STDOUT_FILENO, buf, sz);
		write(STDOUT_FILENO, "\n", 1);

		ds_shuffle(ds);
	}
}

/**
 * Save the network into a file at the given filepath. The serialization format
 * we use here is stupid simple, yet remarkably dense. We simply store the
 * struct how you would expect; first 4 bytes stores the input size, next
 * 4 bytes stores the hidden size, next 8 bytes stores the learning rate,
 * next 8 bytes stores the layer 2 bias, and then we just copy in our big
 * block from memory that has the rest of our weights and biases in it.
 */
void Cnn_save(nn *net, char *filepath) {
	int fd = open(filepath, O_WRONLY | O_CREAT | O_TRUNC, S_IRWXU);
	if (fd < 0) {
		perror("nn_save");
		exit(3);            
	}
	write(fd, &net->input_size, sizeof(int));
	write(fd, &net->hidden_size, sizeof(int));
	write(fd, &net->learning_rate, sizeof(double));
	write(fd, &net->b2, sizeof(double));
	int mem_size = C_compute_mem_reqs(net->input_size, net->hidden_size);
	write(fd, net->w01, mem_size);
	close(fd);
}

/**
 * The corresponding operation to save. The simplicity of the serialization
 * format also makes this incredibly easy. We call nn_init on the net struct
 * just so it sets up the w01, w12, b1, etc pointers for us and zeros out the
 * activations, and then we copy in all of the data from our file.
 * 
 * nn_init mmaps a new space for the data, so we have to copy it over. That
 * renders this file mapping useless, so we munmap it and close it after we
 * are done.
 */
void Cnn_load(nn *net, char *filepath) {
	int fd = open(filepath, O_RDONLY);
	if(fd < 0){
		perror("open");
		exit(4);
	}
	// Need to obtain the size of the file for mmap
	struct stat statbuf;
	int err = fstat(fd, &statbuf);
	if(err < 0){
		perror("fstat");
		exit(5);
	}

	// Very much the reverse operation from save, we just read the file at certain
	// places and those are the exact values we need to populate the struct
	void *file_ptr = mmap(NULL, statbuf.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
	if(file_ptr == MAP_FAILED) {
		printf("file_ptr map failed\n");
		exit(6);
	}
	int input_size = *((int*) file_ptr);
	int hidden_size = *((int*) (file_ptr + sizeof(int)));
	double learning_rate = *((double*) (file_ptr + 2 * sizeof(int)));
	double b2 = *((double*) (file_ptr + 2 * sizeof(int) + sizeof(double)));
	double* w01 = (double*) (file_ptr + 2 * sizeof(int) + 2 * sizeof(double));
	Cnn_init(net, input_size, hidden_size, learning_rate);
	net->b2 = b2;
	int mem_size = hidden_size * (input_size + 3);
	// copy over weights and biases from file
	for(int i = 0; i < mem_size; i++) {
		net->w01[i] = w01[i];
	}
	// free resources
	err = munmap(file_ptr, statbuf.st_size);
	if(err) {
		perror("nn_load munmap");
		exit(7);
	}
	close(fd);
}
