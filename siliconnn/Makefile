CC=gcc
CFLAGS=-Wall

all: demo1

demo1: demo1.o nn.o testing.o ds_destroy.o ds_deep_destroy.o ds_consume_past_char.o ds_parse_int.o ds_parse_double.o ds_parse_data.o ds_load.o ut_random.o ds_shuffle.o ds_train_test_split.o ut_itoa.o ut_dtoa.o ds_show.o ds_normalize.o
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

.PHONY: clean
clean:
	rm -f *.o demo1 demo2 demo3
