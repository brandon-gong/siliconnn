#include "nn.h"

/**
 * Demo 3: Loading saved network from demo.nn, and using it to run predictions
 * on Iris data.
 */
int main(void) {
  seed();

  /*
   * These are the examples with unknown label that we will be predicting using
   * a pre-trained network. The first example has true label 0, the second
   * example has true label 1, and the third example has true label 2.
   * (Of course, this is not known to the network; we are asking it to make
   * predictions)
   */
  double examples_to_predict[3][4] = {
    {5.8, 4.0, 1.2, 0.2},
    {5.5, 2.4, 3.8, 1.1},
    {7.9, 3.8, 6.4, 2.0}
  };

  // Initialize a network with 2 hidden neurons and train for 25 epochs.
  nn net;
  nn_load(&net, "demo.nn");

  write(STDOUT_FILENO, "Predictions:\n", 13);
  char buf[32];
  int sz;
  for(int i = 0; i < 3; i++) {
    sz = dtoa(buf, nn_forward(&net, examples_to_predict[i]), 10);
    write(STDOUT_FILENO, buf, sz);
    write(STDOUT_FILENO, "\n", 1);
  }

  // cleanup
  nn_destroy(&net);
}
