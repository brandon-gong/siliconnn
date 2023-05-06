#include "nn.h"

double _sigmoid(double x) {
	return 1.0 / (1.0 + exp(-x));
}

size_t _compute_mem_reqs(int input_size, int hidden_size) {
	return sizeof(double) * hidden_size * (input_size + 3);
}

void _zero_outputs(nn *net) {
	net->o2 = 0.0;
	for(int i = 0; i < net->hidden_size; i++) {
		net->o1[i] = 0.0;
	}
}

double _random_01() {
	return ((double) rand() / RAND_MAX);
}

void _random_weights(nn *net) {
	for(int i = 0; i < net->hidden_size; i++) {
		for(int j = 0; j < net->input_size; j++) {
			net->w01[j * net->hidden_size + i] = _random_01();
		}
		net->b1[i] = _random_01();
		net->w12[i] = _random_01();
	}
	net->b2 = _random_01();
}

void nn_init(nn *net, int input_size, int hidden_size, double learning_rate) {
	net->input_size = input_size;
	net->hidden_size = hidden_size;
	net->learning_rate = learning_rate;
	int mem_size = _compute_mem_reqs(input_size, hidden_size);
	net->w01 = mmap(NULL, mem_size, PROT_READ | PROT_WRITE,
		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
	if(net->w01 == MAP_FAILED) {
		printf("nn_init map failed\n");
		exit(1);
	}
	net->b1 = net->w01 + input_size * hidden_size;
	net->o1 = net->b1 + hidden_size;
	net->w12 = net->o1 + hidden_size;
	_zero_outputs(net);
	_random_weights(net);
}

void nn_destroy(nn *net) {
	int mem_size = _compute_mem_reqs(net->input_size, net->hidden_size);
	int err = munmap(net->w01, mem_size);
	if(err) {
		perror("nn_destroy munmap");
		exit(1);
	}
}

// TODO very uncertain if my w01 indexing is correct, draw it out and make sure
double nn_forward(nn *net, double *x) {
	_zero_outputs(net);
	for(int i = 0; i < net->input_size; i++) {
		for(int j = 0; j < net->hidden_size; j++) {
			net->o1[j] += x[i] * net->w01[i*net->hidden_size + j];
		}
	}
	for(int i = 0; i < net->hidden_size; i++) {
		net->o1[i] = _sigmoid(net->o1[i] + net->b1[i]);
	}
	for(int i = 0; i < net->hidden_size; i++) {
		net->o2 += net->o1[i] * net->w12[i];
	}
	net->o2 += net->b2;
	return net->o2;
}

void nn_backward(nn *net, double *x, int y) {
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

double nn_average_loss(nn *net, dataset *ds) {
	double total_loss = 0;
	for(int i = 0; i < ds->num_examples; i++) {
		double pred = nn_forward(net, ds->examples[i]->example);
		double err = ds->examples[i]->label - pred;
		total_loss += err*err;
	}
	return total_loss / ds->num_examples;
}

// fprop and bprop done, just need to impl accuracy and train methods, and
// saving / loading model
void nn_train(nn *net, dataset *ds, int num_epochs) {
	char buf[32];
	int sz;
	for(int i = 0; i < num_epochs; i++) {
		for(int j = 0; j < ds->num_examples; j++) {
			nn_forward(net, ds->examples[j]->example);
			nn_backward(net, ds->examples[j]->example, ds->examples[j]->label);
		}
		double loss = nn_average_loss(net, ds);
		write(STDOUT_FILENO, "Epoch ", 6);
		sz = itoa(buf, i);
		write(STDOUT_FILENO, buf, sz);
		write(STDOUT_FILENO, " | Loss: ", 9);
		sz = dtoa(buf, loss, 10);
		write(STDOUT_FILENO, buf, sz);
		write(STDOUT_FILENO, "\n", 1);

		ds_shuffle(ds);
	}
}

void nn_save(nn *net, char *filepath) {
	int fd = open(filepath, O_WRONLY | O_CREAT | O_TRUNC, S_IRWXU);
	if (fd < 0) {
		perror("nn_save");
		exit(1);            
	}
	write(fd, &net->input_size, sizeof(int));
	write(fd, &net->hidden_size, sizeof(int));
	write(fd, &net->learning_rate, sizeof(double));
	write(fd, &net->b2, sizeof(double));
	int mem_size = _compute_mem_reqs(net->input_size, net->hidden_size);
	write(fd, net->w01, mem_size);
	close(fd);
}

void nn_load(nn *net, char *filepath) {
	int fd = open(filepath, O_RDONLY);
	if(fd < 0){
		perror("open");
		exit(1);
	}
	// Need to obtain the size of the file for mmap
	struct stat statbuf;
	int err = fstat(fd, &statbuf);
	if(err < 0){
		perror("fstat");
		exit(1);
	}

	void *file_ptr = mmap(NULL, statbuf.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
	int input_size = *((int*) file_ptr);
	int hidden_size = *((int*) (file_ptr + sizeof(int)));
	double learning_rate = *((double*) (file_ptr + 2 * sizeof(int)));
	double b2 = *((double*) (file_ptr + 2 * sizeof(int) + sizeof(double)));
	double* w01 = (double*) (file_ptr + 2 * sizeof(int) + 2 * sizeof(double));
	nn_init(net, input_size, hidden_size, learning_rate);
	net->b2 = b2;
	int mem_size = hidden_size * (input_size + 3);
	for(int i = 0; i < mem_size; i++) {
		net->w01[i] = w01[i];
	}
	err = munmap(file_ptr, statbuf.st_size);
	if(err) {
		perror("nn_load munmap");
		exit(1);
	}
}
