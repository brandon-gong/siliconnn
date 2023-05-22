#include <unistd.h>

typedef struct data { int label; double* example; } data;
typedef struct dataset { data **examples; int num_examples; int num_attributes; data *_mmap_ptr; } dataset;
typedef struct nn { int input_size; int hidden_size; double learning_rate; double* w01; double* b1; double* o1; double* w12; double b2; double o2; } nn;
extern int itoa(char *buf, int x);
extern int dtoa(char *buf, double x, int precision);
extern void seed();
extern void ds_destroy(dataset *ds);
extern void ds_deep_destroy(dataset *ds);
extern void ds_load(char* fpath, int numrows, int numcols, dataset *ds);
extern void ds_shuffle(dataset *ds);
extern void ds_train_test_split(dataset *original, dataset *train_set, dataset *test_set, double test_ratio);
extern void ds_show(dataset *ds);
extern void ds_normalize(dataset *ds);
extern void nn_init(nn *net, int input_size, int hidden_size, double learning_rate);
extern void nn_destroy(nn *net);
extern double nn_forward(nn *net, double *x);
extern void nn_backward(nn *net, double *x, int y);
extern void nn_train(nn *net, dataset *ds, int num_epochs);
extern double nn_average_loss(nn *net, dataset *ds);
extern void nn_save(nn *net, char *filepath);
extern void nn_load(nn *net, char *filepath);

int main(void) {

  seed();
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
  //nn_destroy(&n1);
  ds_deep_destroy(&ds);


  double examples_to_predict[3][4] = {
    {5.8, 4.0, 1.2, 0.2},
    {5.5, 2.4, 3.8, 1.1},
    {7.9, 3.8, 6.4, 2.0}
  };

  // Initialize a network with 2 hidden neurons and train for 25 epochs.
  // printf("%d\n", nn_load(&n2, "demo.nn"));
  nn_load(&n2, "demo.nn");

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
