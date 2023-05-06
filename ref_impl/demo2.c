#include "nn.h"

/**
 * Demo 2: Loading Iris CSV dataset, training on network, and saving to file
 * "demo.nn".
 */
int main(void) {
  seed();

  // Load the Iris dataset.
  dataset ds;
  ds_load("../test_sets/iris.csv", 151, 5, &ds);

  // Initialize a network with 2 hidden neurons and train for 25 epochs.
  nn net;
  nn_init(&net, 4, 2, 0.05);
  nn_train(&net, &ds, 25);

  // Save the trained result to demo.nn
  nn_save(&net, "demo.nn");

  // cleanup
  nn_destroy(&net);
  ds_deep_destroy(&ds);
}