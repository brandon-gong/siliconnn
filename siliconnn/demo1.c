#include "nn.h"
#include <stddef.h>

int main(void) {
  //seed();

  //printf("%lu\n", offsetof(nn, b2));

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
  Cnn_train(&net, &train, 100);

  // Show average loss on the test set.
  write(STDOUT_FILENO, "Avg test loss: ", 15);
  char buf[32];
  int sz = dtoa(buf, Cnn_average_loss(&net, &test), 10);
  write(STDOUT_FILENO, buf, sz);

  // cleanup
  Cnn_destroy(&net);
  ds_destroy(&train);
  ds_destroy(&test);
  ds_deep_destroy(&ds);

  //   dataset ds;
  // ds_load("../test_sets/iris.csv", 151, 5, &ds);
  // 

  // // Initialize a network with 2 hidden neurons and train for 25 epochs.
  // nn net;
  // nn_init(&net, 4, 2, 0.05);
  // Cnn_train(&net, &ds, 25);
  // ds_destroy(&ds);
  // Cnn_destroy(&net);
}
