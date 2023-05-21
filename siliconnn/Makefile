CC=gcc
CFLAGS=-Wall

all: demo1

demo1: demo1.o nn.o testing.o ds_destroy.o ds_deep_destroy.o ds_consume_past_char.o ds_parse_int.o ds_parse_double.o ds_parse_data.o ds_load.o ut_random.o ds_shuffle.o ds_train_test_split.o ut_itoa.o ut_dtoa.o ds_show.o ds_normalize.o nn_formula.o nn_zero_outputs.o nn_random_weights.o nn_init.o  nn_destroy.o nn_forward.o nn_backward.o nn_average_loss.o nn_train.o
	$(CC) $(CFLAGS) $^ -o demo1

nn.o: nn.c nn.h
	$(CC) $(CFLAGS) -c $< -o $@

testing.o: nn/testing.s
	as -arch arm64 -o testing.o nn/testing.s

ds_destroy.o: dataset/destroy.s
	as -arch arm64 -o ds_destroy.o dataset/destroy.s

ds_deep_destroy.o: dataset/deep_destroy.s
	as -arch arm64 -o ds_deep_destroy.o dataset/deep_destroy.s

ds_consume_past_char.o: dataset/consume_past_char.s
	as -arch arm64 -o ds_consume_past_char.o dataset/consume_past_char.s

ds_parse_int.o: dataset/parse_int.s
	as -arch arm64 -o ds_parse_int.o dataset/parse_int.s

ds_parse_double.o: dataset/parse_double.s
	as -arch arm64 -o ds_parse_double.o dataset/parse_double.s

ds_parse_data.o: dataset/parse_data.s
	as -arch arm64 -o ds_parse_data.o dataset/parse_data.s

ds_load.o: dataset/load.s
	as -arch arm64 -o ds_load.o dataset/load.s

ds_shuffle.o: dataset/shuffle.s
	as -arch arm64 -o ds_shuffle.o dataset/shuffle.s

ds_train_test_split.o: dataset/train_test_split.s
	as -arch arm64 -o ds_train_test_split.o dataset/train_test_split.s

ds_show.o: dataset/show.s
	as -arch arm64 -o ds_show.o dataset/show.s

ds_normalize.o: dataset/normalize.s
	as -arch arm64 -o ds_normalize.o dataset/normalize.s

ut_random.o: util/random.s
	as -arch arm64 -o ut_random.o util/random.s

ut_itoa.o: util/itoa.s
	as -arch arm64 -o ut_itoa.o util/itoa.s

ut_dtoa.o: util/dtoa.s
	as -arch arm64 -o ut_dtoa.o util/dtoa.s

nn_formula.o: nn/formula.s
	as -arch arm64 -o nn_formula.o nn/formula.s

nn_zero_outputs.o: nn/zero_outputs.s
	as -arch arm64 -o nn_zero_outputs.o nn/zero_outputs.s

nn_random_weights.o: nn/random_weights.s
	as -arch arm64 -o nn_random_weights.o nn/random_weights.s

nn_init.o: nn/init.s
	as -arch arm64 -o nn_init.o nn/init.s

nn_destroy.o: nn/destroy.s
	as -arch arm64 -o nn_destroy.o nn/destroy.s

nn_forward.o: nn/forward.s
	as -arch arm64 -o nn_forward.o nn/forward.s

nn_backward.o: nn/backward.s
	as -arch arm64 -o nn_backward.o nn/backward.s

nn_average_loss.o: nn/average_loss.s
	as -arch arm64 -o nn_average_loss.o nn/average_loss.s

nn_train.o: nn/train.s
	as -arch arm64 -o nn_train.o nn/train.s


.PHONY: clean
clean:
	rm -f *.o demo1 demo2 demo3
