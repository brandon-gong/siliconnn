#include "nn.h"

int main(void) {
  // Cseed();

  
  
  //dataset ds;
  //Cds_load("../test_sets/iris.csv", 151, 5, &ds);
  //ds_load("../test_sets/wine.csv", 179, 14, &ds);
  //Cds_show(&ds);
  //ds_deep_destroy(&ds);
  
  //dataset ds;
  //Cds_load("../test_sets/wine.csv", 179, 14, &ds);
  //Cds_load("../test_sets/breast-cancer-wisconsin.csv", 570, 31, &ds);
  //Cds_load("../test_sets/iris.csv", 151, 5, &ds);
  //Cds_show(&ds);
  //Cds_normalize(&ds);

  //nn net;
  //Cnn_init(&net, 13, 8, 0.05);
  //Cnn_train(&net, &ds, 25);

  //ds_deep_destroy(&ds);

  // extern void consume_past_char(char** ptr, char *end, char c);
  // char *s = "qeertw";
  // char *end = s + 6;
  // consume_past_char(&s, end, 'w');
  // printf("sruvi%s\n", s);

  
  // char* test = "001,qwer4\n";
  // double x = parse_double(&test);
  // printf("%f\n%s\n", x, test);


  extern double rand01();
  extern void seed();
  extern  long rand_ul();
  seed();
  for(int i = 0; i < 100; i++) {
    printf("%f\n", rand01());
  }
  for(int i = 0; i < 100; i++) {
    printf("%ld\n", rand_ul() % 3);
  }

  
}
