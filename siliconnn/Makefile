UTIL_S=$(wildcard util/*.s)
UTIL_O=$(patsubst util/%.s,ut_%.o,$(UTIL_S))

DS_S=$(wildcard dataset/*.s)
DS_O=$(patsubst dataset/%.s,ds_%.o,$(DS_S))

NN_S=$(wildcard nn/*.s)
NN_O=$(patsubst nn/%.s,nn_%.o,$(NN_S))

OBJS = $(UTIL_O) $(DS_O) $(NN_O)

TARGETS = demo1 demo2 demo3

all: $(TARGETS)

demo%: demo%.o $(OBJS)
	ld -o $@ $^ -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -arch arm64

demo%.o: demo%.s
	as -arch arm64 -o $@ $^

ut_%.o: util/%.s
	as -arch arm64 -o $@ $^

ds_%.o: dataset/%.s
	as -arch arm64 -o $@ $^

nn_%.o: nn/%.s
	as -arch arm64 -o $@ $^

.PHONY: clean
clean:
	rm -rf demo1 demo2 demo3 demo.nn
