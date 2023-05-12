# (silicon)nn Reference Implementation
This is the C reference implementation that was translated to Assembly
by hand.

I won't discuss too many technical details of siliconnn itself here (go
check [this `README`](https://github.com/brandon-gong/siliconnn/blob/main/siliconnn/README.md)
instead for that), but here are some C-specific comments:

## Differences from "typical" C implementation
The goal of siliconnn is to be a pure Assembly implementation of neural networks – so
no convenience functions from C.

In order to make this work, I had to make sure that every standard library
function call made by siliconnn (anything included by `#include <...>`) is backed
by either a straight arm64 instruction, or is a system call. For example, we
don't have `sqrt()` or `exp()` from the standard library, but thankfully ARM
gives us `FSQRT`.

This is generally
fine, save for four key features we are missing from C:

- We don't have access to `malloc`. We get by this quite
easily by using `mmap` instead; while `mmap` is potentially slower, it doesn't
really matter for us, since we only need to allocate memory for ourselves
a few times for loading the training data and making space for weights.
All in all, `mmap` is called about 6-7 times total for initialization,
training, and running, which is really not that much.
- No `printf`. This is actually quite a pain, and so siliconnn has to
come with its own impleentations of `itoa` and `dtoa`. They aren't perfect,
but good enough for our purposes. Everything has to be written in terms of
these functions and `write`.
- No `rand()` or `srand()`. To get around this, the Assembly source of siliconnn
includes its own `random` module with an implementation of the XorShift64*
pseudo-random number generator. There is no corresponding reference implementation
to this here (the code listing is provided on [Wikipedia](https://en.wikipedia.org/wiki/Xorshift#xorshift*)),
but the reference implementation for seeding is followed.
- No `exp()`. I also cannot figure out how to do the exponential function in Assembly.
The documentation mentions a `FEXPA` instruction, but whenever I try to use it I
get a `SIGILL`. And Apple has made it literally impossible to figure out what they
do on their end. Thus I am just using the standard library `exp` for now.

The code is written to avoid recursion and avoid returning structs or
anything complicated like that. I also do not make use of preprocessing facilities
(save for include guards) because I needed everything to be written out explicitly
for transcribing. However, it otherwise is decent quality;
it doesn't skip over things like memory cleanup.

## Notes on the transcribing process
Once the reference implementation was completed, a copy of all of the code was made
to the `siliconnn` directory. Then, bit-by-bit, Ship of Theseus style, functions
were replaced by their Assembly equivalents.

You can easily call Assembly functions from C (by declaring, for example,
`extern int add(int a, int b)` in the C file, and then exporting the corresponding
function from an assembly file with `.global _add`). This was used heavily to
test the functionality of one small piece of Assembly at a time, with all of the
nice features from C like `printf`.

Eventually, once all C functions had been translated to Assembly, I could drop my
dependence on `gcc` in the `Makefile`.

You will also notice that files here (e.g. `dataset.c`, `nn.c`) correspond to
directories in the Assembly implementation. I chose to split every function into
its own `.s` function, purely because of the overwhelmingly long and cryptic
nature of Assembly. Keeping all of the files matching would have lead to some
massive Assembly files that would be impossible to work with.
