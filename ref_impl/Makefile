CC=gcc
CFLAGS=-Wall
TARGET=test

all: $(TARGET)

test: main.o dataset.o nn.o
	$(CC) $(CFLAGS) $^ -o $(TARGET)

main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

dataset.o: dataset.c dataset.h
	$(CC) $(CFLAGS) -c $< -o $@

nn.o: nn.c nn.h
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f *.o $(TARGET)
