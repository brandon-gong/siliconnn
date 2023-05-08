# (silicon)nn
Siliconnn is a small yet surprisingly featureful neural network implementation, written in pure ARM64 (AArch64) assembly for Apple Silicon.
Included in this repository is the arm64 assembly source as well as the C reference implementation (which I also wrote from scratch, specifically
for this project) that the assembly code was based upon.

To be clear, siliconnn does _not_ depend on its C reference implementation, nor does it depend on _any_ C standard library functions;
no `malloc`, no `atoi`, no `printf`. Everything that is needed is implemented from scratch in assembly.

Both folders have their own README's containing some more specific technical details
about their implementations, as well as `Makefile`s; running `make` in each will generate three demos (the demos behave identically between
the reference implementation and siliconnn), demonstrating the following features:
- `demo1`: Loading the [UCI Wine](https://archive.ics.uci.edu/ml/datasets/wine) dataset, normalizing features, splitting into training and testing sets, training and testing
- `demo2`: Loading the [Iris](https://archive.ics.uci.edu/ml/datasets/iris) dataset, training, and dumping the trained network to a file.
- `demo3`: Loading a pretrained network from a file and using it to classify some unlabeled iris examples.

## Features
- **CSV parsing**. You can load training data in through CSV files. There are some limitations; only numerical values are allowed, labels must be integers, and
  the label column must be first. But besides this, the CSV parser is pretty durable:
  - It correctly interprets missing/empty cells (`,,`) as 0
  - It can parse floats flexibly, so long as they are not in scientific notation. e.g. `10.`, `-.002`, `3`, `3.14159` all parse correctly.
  - If there is a single syntax error in a cell, it parses as much of the number it can and skips forward to the next cell.
  - If there are more cells in a row than expected, the extraneous cells are skipped.
  - Positive and negative labels are also supported.
- **Feature normalization**. This is such an important step for most ML tasks, its included as a feature here. Once data is loaded via CSV, features can be normalized,
  which adjusts all attributes to have mean of 0 and standard deviation of 1. This ensures no one particular attribute unfairly outweighs other attributes during
  training.
- **Shuffling**. Shuffling is also quite a commonly-needed utility; you might want to shuffle your examples before train-test-split (e.g. the Iris dataset comes
  sorted by label, definitely not what we want), or shuffle your examples between epochs during training. Siliconnn can shuffle the examples in a dataset using
  Fisher-Yates on top of its own PRNG implementation.
- **Train-test-split**. You put in one dataset, you get back two datasets which you can use as you please. Typically, you use one for training, and use the other for
  validating your model, i.e. checking how well it generalizes to unseen data.
  - The API here is inspired by [Sklearn's `train-test-split`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html) in that you can specify the ratio of test size to train size.
  - This is highly memory-efficient; there is no underlying duplication of the data. You can think of the two datasets you get back as two disjoint "views" of the
  same data.
- **Printing datasets**. Just for debug purposes, prints out all the examples in a dataset with their labels in a CSV-esque format.
- **Feedforward neural networks with one hidden layer**. This is the heart of the project.
  - Sigmoid activation on the hidden layer.
  - Layers are fully connected.
  - Single output neuron corresponding to prediction (no sigmoid applied, but there is a bias term)
  - Adjustable input and hidden layer size. Amount of space allocated for the network is dynamically computed depending on these settings.
- **Training with stochastic gradient descent**. The batch size is not tunable as of now (always 1).
  - You can specify learning rate + number of epochs.
  - Logs helpful info (epoch number, average L2 loss) to the console after each epoch to aid in hyperparameter tuning.
- **Loss computation**. Siliconnn can compute a network's average L2 loss (aka Mean Squared Error) over a given dataset.
- **Saving/loading models**. Want to pretrain a model, dump it to a file, and recover the model somewhere else without having to retrain it? Siliconnn can do that.
- **Legibility**. The assembly source is readable (well, about as readable as assembly can get). It is written letter-for-letter by hand, with zero help from
  compilers, and I personally think it shows; every instruction has a logical and clear reason for being there (unlike `gcc` output, which takes a decent bit
  of effort to decipher), and there's generally more comments than code.
- **Tiny compile size**. The entirety of siliconnn compiles to a single 20 KB binary. For reference, the following Hello World C program, compiled with `gcc test.c -o test`, compiles to a 33 KB binary:
  ```C
  #include <stdio.h>
  
  int main(void) {
    printf("Hello world!\n");
  }
  ```
  (No, I am not saying this is the smallest Hello World binary you can get from C, but this is definitely the most common and straightforward one.)
- **Resource management**. Siliconnn dynamically allocates precisely as much memory as it needs to represent the network and datasets (no more and no less),
  deallocates whatever it allocates by providing `destroy` functions for everything, closes all of the files it opens, etc.
- **Error checking**. System calls can fail for various reasons, and siliconnn exits gracefully on failure. I didn't have it print any error messages (since that
  would be extremely tedious without `perror` or `printf`), but it will return one of the following unique non-zero exit codes depending on the reason of the crash:
  
  | code | crash reason |
  |------|--------------|
  | 1 | nn_init mmap failed |
  | 2 | nn_destroy munmap failed |
  | 3 | nn_save failed to open file for writing |
  | 4 | nn_load failed to open file for reading |
  | 5 | nn_load failed to get file size info (fstat) |
  | 6 | nn_load mmap failed |
  | 7 | nn_load munmap failed |
  | 8 | ds_destroy munmap failed |
  | 9 | ds_deep_destroy munmap failed |
  | 10 | ds_load mmap failed for data block |
  | 11 | ds_load failed to open file for reading |
  | 12 | ds_load failed to get file size info (fstat) |
  | 13 | ds_load failed to mmap the file |
  | 14 | ds_load mmap failed for examples block |
  | 15 | ds_load munmap failed for file |
  
## Non-features
- **Portability**. This has been tested on my M1 Macbook Pro, and I would assume it would work on any other Apple Silicon Mac, but I don't have access to an array of
  Apple devices to test this. And I am almost certain it won't run anywhere else. This is just the unfortunate reality of assembly.
- **Practicality**. If you are using Siliconnn unironically, why?
- **Speed**. This does not take advantage of GPU compute, or even SIMD (yet!). Thus it is almost assuredly slower than most NN implementations.
- **Flexibility**. Neural networks with 1 hidden sigmoid layer and 1 output can do a decent job at quite a lot of tasks, but not all. I won't be implementing
  extra layers, or other activation functions, or other architectures (e.g. CNN, RNN) anytime soon, again because this is meant to be more of a teaching/learning
  experience than practically useful.
