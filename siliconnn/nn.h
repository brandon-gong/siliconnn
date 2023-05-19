#ifndef _NN_H_
#define _NN_H_

#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <math.h>

extern int itoa(char *buf, int x);
extern int dtoa(char *buf, double x, int precision);
extern void seed();
extern long rand_ul();
extern double rand01();

typedef struct data { int label; double* example; } data;
typedef struct dataset {
	data **examples;
	int num_examples;
	int num_attributes;
	data *_mmap_ptr;
} dataset;

extern void ds_destroy(dataset *ds);
extern void ds_deep_destroy(dataset *ds);
extern void ds_load(char* fpath, int numrows, int numcols, dataset *ds);
extern void ds_shuffle(dataset *ds);
extern void ds_train_test_split(dataset *original, dataset *train_set,
	dataset *test_set, double test_ratio);
extern void ds_show(dataset *ds);
extern void ds_normalize(dataset *ds);


/**
 * This is the actual neural network implementation. We obviously can't implement
 * neural networks in their full generality here, so what we implement is a
 * two-layer neural network (one hidden layer) with sigmoid activation on the
 * hidden layer only. The number of neurons in the input and hidden layers are
 * adjustable at runtime. We implement functions for training the neural
 * networks, running predictions, initializing/destroying, and saving/loading.
 */

typedef struct nn {
	// The size of the input layer.
	int input_size;
	// The size of the hidden layer.
	int hidden_size;
	// The learning rate (hyperparameter)
	double learning_rate;

	// These are the network's internal parameters. b2 and o2 are stored within
	// the struct itself, while everything else (size not known until runtime)
	// is dynamically allocated as one big block. So you can think of it as
	// w01, b1, o1, and w12 as just pointers to different places in the same
	// contiguous memory array.

	// The weights of the connections between the input and the hidden layer.
	// There are input_size * hidden_size such connections
	double* w01;
	// Hidden layer biases
	double* b1;
	// Hidden layer outputs, stored for backprop
	double* o1;
	// Weights between hidden layer and output neuron. there are hidden_size
	// such connections
	double* w12;
	// output neuron bias
	double b2;
	// output neuron output, stored for backprop
	double o2;
} nn;

/**
 * Initializes a neural network from the given input layer size, hidden layer
 * size, and learning rate. This function zeros out all outputs and randomizes
 * all of the weights, so networks are ready to train.
 * 
 * @param net a reference to the nn struct to initialize
 * @param input_size the number of input neurons, should match num_attributes
 * 	in the training data.
 * @param hidden_size the number of hidden neurons. This can be tuned, but must
 * 	be greater than 0.
 * @param learning_rate the learning rate. Should be strictly positive
 * 	(and probably small) value.
 */
//void Cnn_init(nn *net, int input_size, int hidden_size, double learning_rate);
extern void nn_init(nn *net, int input_size, int hidden_size, double learning_rate);

/**
 * Frees resources associated with this nn (just the big w01+b1+o1+w12 array)
 */
// void Cnn_destroy(nn *net);
extern void nn_destroy(nn *net);

/**
 * Given an example, generate a prediction by doing a forward pass through the
 * network. This modifies the network's o1 and o2 properties, and also returns
 * o2 after the forward pass has been computed for convenience.
 * 
 * @param net the network to run the example through
 * @param x the example
 * @return the network's final prediction
 */
double Cnn_forward(nn *net, double *x);

/**
 * Given an example and its true label, update the network weights via 
 * backpropagation. You must run nn_forward on this same example before calling
 * this function for reasonable results. This function modifies the w01, b1,
 * w12, and b2 values.
 * 
 * @param net the network to update
 * @param x the example that was just run through the net with nn_forward
 * @param y the example's true label
 */
void Cnn_backward(nn *net, double *x, int y);

/**
 * Trains a neural network on the given dataset for the specified number of
 * epochs. Training is done via stochastic gradient descent with a batch size
 * of 1. After each epoch, useful stats such as epoch number and average loss
 * are logged.
 * 
 * @param net the network to train
 * @param ds the dataset to train on
 * @param num_epochs the number of epochs to train for
 */
void Cnn_train(nn *net, dataset *ds, int num_epochs);

/**
 * Computes the average L2 loss of the network. If n is the number of examples,
 * x is the networks predictions, and y are the true labels, this is given by
 * \frac{1}{n}\sum_{i=0}^{n}(x_i - y_i)^2.
 * Lower values are more desirable. Use this function to tune your
 * hyperparameters and minimize this value on the held-out test set.
 * 
 * @param net the network to compute average loss on
 * @param ds the dataset to compute average loss for. This will call nn_forward
 * 	on each example in ds.
 */
double Cnn_average_loss(nn *net, dataset *ds);

/**
 * Saves the network to a file at the given filepath.
 */
void Cnn_save(nn *net, char *filepath);

/**
 * Loads a network from the given filepath into net. You can use this and
 * nn_save to pretrain a model on a large set of training data, save it,
 * and load it later (perhaps in a context without the training data) and have
 * it be ready to go.
 */
void Cnn_load(nn *net, char *filepath);

#endif