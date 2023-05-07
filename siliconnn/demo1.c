#include "nn.h"

int main(void) {
  // Cseed();

  // // Loading dataset from file, and shuffling all the examples.
  // dataset ds;
  // Cds_load("../test_sets/wine.csv", 179, 14, &ds);
  // Cds_normalize(&ds);
  // Cds_shuffle(&ds);

  // // Train-test split the examples into a test set (20% of the data) and a
  // // training set (80% of the data). Print them out for debug purposes.
  // dataset train, test;
  // Cds_train_test_split(&ds, &train, &test, 0.2);
  // write(STDOUT_FILENO, "\n----------TRAIN SET-----------\n", 32);
  // Cds_show(&train);
  // write(STDOUT_FILENO, "\n----------TEST SET-----------\n", 31);
  // Cds_show(&test);

  // // Init a network with 8 hidden neurons and a learning rate of 0.05. Then
  // // train the network on the training set for 25 epochs.
  // nn net;
  // Cnn_init(&net, 4, 8, 0.05);
  // Cnn_train(&net, &train, 25);

  // // Show average loss on the test set.
  // write(STDOUT_FILENO, "Avg test loss: ", 15);
  // char buf[32];
  // int sz = Cdtoa(buf, Cnn_average_loss(&net, &test), 10);
  // write(STDOUT_FILENO, buf, sz);

  // // cleanup
  // Cnn_destroy(&net);
  // Cds_destroy(&train);
  // Cds_destroy(&test);
  // Cds_deep_destroy(&ds);
  
  dataset ds;
  Cds_load("../test_sets/wine.csv", 179, 14, &ds);
  Cds_show(&ds);
  ds_deep_destroy(&ds);

  // extern void consume_past_char(char** ptr, char *end, char c);
  // char *s = "qeertw";
  // char *end = s + 6;
  // consume_past_char(&s, end, 'w');
  // printf("sruvi%s\n", s);
}
