#include "nn.h"

/**
 * Demo 1: Loading Wine CSV dataset, demonstrate dataset train-test-split and
 * printing functionality, training on network, and printing test loss.
 */
int main(void) {
  seed();

  // Loading dataset from file, and shuffling all the examples.
  dataset ds;
  ds_load("../test_sets/wine.csv", 179, 14, &ds);
  ds_normalize(&ds);
  ds_shuffle(&ds);

  // Train-test split the examples into a test set (20% of the data) and a
  // training set (80% of the data). Print them out for debug purposes.
  dataset train, test;
  ds_train_test_split(&ds, &train, &test, 0.2);
  write(STDOUT_FILENO, "\n----------TRAIN SET-----------\n", 32);
  ds_show(&train);
  write(STDOUT_FILENO, "\n----------TEST SET-----------\n", 31);
  ds_show(&test);

  // Init a network with 8 hidden neurons and a learning rate of 0.05. Then
  // train the network on the training set for 25 epochs.
  nn net;
  nn_init(&net, 13, 18, 0.01);
  nn_train(&net, &train, 100);

  // Show average loss on the test set.
  write(STDOUT_FILENO, "Avg test loss: ", 15);
  char buf[32];
  int sz = dtoa(buf, nn_average_loss(&net, &test), 10);
  write(STDOUT_FILENO, buf, sz);

  // cleanup
  nn_destroy(&net);
  ds_destroy(&train);
  ds_destroy(&test);
  ds_deep_destroy(&ds);
}
