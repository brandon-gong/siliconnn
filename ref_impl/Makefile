CC=gcc
CFLAGS=-Wall

all: demo1 demo2 demo3

demo3: demo3.o dataset.o nn.o util.o
	$(CC) $(CFLAGS) $^ -o demo3

demo2: demo2.o dataset.o nn.o util.o
	$(CC) $(CFLAGS) $^ -o demo2

demo1: demo1.o dataset.o nn.o util.o
	$(CC) $(CFLAGS) $^ -o demo1

demo1.o: demo1.c
	$(CC) $(CFLAGS) -c $< -o $@

demo2.o: demo2.c
	$(CC) $(CFLAGS) -c $< -o $@

demo3.o: demo3.c
	$(CC) $(CFLAGS) -c $< -o $@

dataset.o: dataset.c dataset.h
	$(CC) $(CFLAGS) -c $< -o $@

nn.o: nn.c nn.h
	$(CC) $(CFLAGS) -c $< -o $@

util.o: util.c util.h
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f *.o demo1 demo2 demo3
