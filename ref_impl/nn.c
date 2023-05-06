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
	double res = ((double) rand() / RAND_MAX);
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

void _itoa(char *buf, int x) {
	int n = 0;
	while (x > 0) {
		buf[n] = x % 10;
		x /= 10;
		n++;
	}

	for(int i = 0; i < n / 2; i++) {
		char tmp = buf[i];
		buf[i]  = buf[n - i - 1];
		buf[n - i - 1] = tmp;
	}
	buf[n] = '\0';
}

double nn_average_loss(nn *net, dataset *ds) {
	for(int i = 0; i < ds->num_examples; i++) {
		// TODO
	}
}

// fprop and bprop done, just need to impl accuracy and train methods, and
// saving / loading model
void nn_train(nn *net, dataset *ds, int num_epochs) {
	for(int i = 0; i < num_epochs; i++) {
		for(int j = 0; j < ds->num_examples; j++) {
			nn_forward(net, ds->examples[j]->example);
			nn_backward(net, ds->examples[j]->example, ds->examples[j]->label);
		}
		//nn_log_accuracy(net, ds);
		ds_shuffle(ds);
	}
}

void nn_save(nn *net, char *filepath) {
	int fd = open(filepath, O_WRONLY | O_CREAT | O_TRUNC, S_IRWXU | S_IRWXG | S_IRWXO);
	if (fd < 0) {
		perror("nn_save");    
		exit(1);            
	}
	write(fd, &net->input_size, sizeof(int));
	write(fd, &net->hidden_size, sizeof(int));
	write(fd, &net->learning_rate, sizeof(double));
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
	err = munmap(file_ptr, 2 * sizeof(int) + sizeof(double));
	if(err) {
		perror("ds_destroy munmap");
		exit(1);
	}
	file_ptr += 2 * sizeof(int) + sizeof(double);
	nn_init(net, input_size, hidden_size, learning_rate);
	net->w01 = (double*) file_ptr;
}
