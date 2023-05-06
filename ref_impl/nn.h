#ifndef _NN_H_
#define _NN_H_

#include "dataset.h"

typedef struct nn {
	int input_size;
	int hidden_size;
	double learning_rate;
	double* w01;
	double* b1;
	double* o1;
	double* w12;
	double b2;
	double o2;
} nn;

void nn_init(nn *net, int input_size, int hidden_size, double learning_rate);
void nn_destroy(nn *net);

double nn_forward(nn *net, double *x);
void nn_backward(nn *net, double *x, int y);

void nn_train(nn *net, dataset *ds, int num_epochs);
int nn_predict(nn *net, double *x);

void nn_save(nn *net, char *filepath);
void nn_load(nn *net, char *filepath);

#endif