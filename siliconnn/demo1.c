#include "nn.h"
#include <stddef.h>

int main(void) {
  // Load the Iris dataset.
  dataset ds;
  ds_load("../test_sets/iris.csv", 151, 5, &ds);

  // Initialize a network with 2 hidden neurons and train for 25 epochs.
  nn n1, n2;
  nn_init(&n1, 4, 2, 0.05);
  nn_train(&n1, &ds, 25);

  // Save the trained result to demo.nn
  nn_save(&n1, "demo.nn");

  // cleanup
  nn_destroy(&n1);
  ds_deep_destroy(&ds);


  double examples_to_predict[3][4] = {
    {5.8, 4.0, 1.2, 0.2},
    {5.5, 2.4, 3.8, 1.1},
    {7.9, 3.8, 6.4, 2.0}
  };

  // Initialize a network with 2 hidden neurons and train for 25 epochs.
  Cnn_load(&n2, "demo.nn");

  write(STDOUT_FILENO, "Predictions:\n", 13);
  char buf[32];
  int sz;
  for(int i = 0; i < 3; i++) {
    sz = dtoa(buf, nn_forward(&n2, examples_to_predict[i]), 10);
    write(STDOUT_FILENO, buf, sz);
    write(STDOUT_FILENO, "\n", 1);
  }

  // cleanup
  nn_destroy(&n2);
}
