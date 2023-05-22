CC=gcc
CFLAGS=-Wall

OBJ=util.o dataset.o nn.o

all: demo1 demo2 demo3

demo%: demo%.o $(OBJ)
	$(CC) $(CFLAGS) $^ -o $@

demo%.o: demo%.c
	$(CC) $(CFLAGS) -c $^ -o $@

%.o: %.c %.h
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f *.o demo1 demo2 demo3
