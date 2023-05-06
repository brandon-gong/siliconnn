This is the C reference implementation that will be transcribed to Assembly
by hand. In order to make this work, we have to make sure that every stdlib
call we make (functions we use that are included by `#include <...>`) is backed
by either a straight arm64 instruction, or is a system call.

Particularly of note, we don't have access to `malloc`. We get by this quite
easily by using `mmap` instead; while `mmap` is potentially slower, it doesn't
really matter for us, since we only need to allocate memory for ourselves
a few times for loading the training data and making space for weights.
All in all, `mmap` is called about 6-7 times total for initialization,
training, and running, which is really not that much.

The code is also written to avoid recursion and avoid returning structs or
anything complicated like that. However, it otherwise is decent quality;
we don't skip over things like memory cleanup.
