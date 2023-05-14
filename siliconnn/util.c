#include "util.h"

/*
 * We don't support negative ints, simply because we don't need them!
 * This can very easily be expanded to support negatives at any point, I just
 * want to reduce the workload of rewriting this in asm later
 */
// int Citoa(char *buf, int x) {
// 	// n holds the index of the buffer into which we are writing
// 	int n = 0;
// 	// Special case, x=0
// 	if (x == 0) {
// 		buf[0] = '0';
// 		return 1;
// 	}

// 	while (x > 0) {
// 		buf[n] = (x % 10) + '0';
// 		x /= 10;
// 		n++;
// 	}

// 	// Reverse the digits of the buffer up to the nth character, since we put the
// 	// ones digit in buf[0], tens digit in buf[1], etc.
// 	for(int i = 0; i < n / 2; i++) {
// 		char tmp = buf[i];
// 		buf[i]  = buf[n - i - 1];
// 		buf[n - i - 1] = tmp;
// 	}
// 	return n;
// }

/*
 * Printing doubles is notoriously harder than it looks, but I am not too 
 * concerned about precision. We won't be dealing with scientific notation,
 * or infinities, or NaN in this implementation.
 */
int Cdtoa(char *buf, double x, int precision) {
	// Special cases: if zero, just return 0, and if negative, add a - to the
	// buffer and make it positive
	if (x == 0) {
		buf[0] = '0';
		return 1;
	}
	int isneg = 0;
	if (x < 0) {
		isneg = 1;
		buf[0] = '-';
		x *= -1;
	}
	int n = itoa(buf + isneg, (int) x);
	n += isneg;
	// Add the decimal point and increment n
	buf[n++] = '.';

	// This little maneuver is the best way I could figure out how to get the
	// fraction part of a number, not sure if there's a better way
	x = x - ((int) x);
	// Similar process to itoa except happily we don't need to worry about
	// reversing
	for(int i = 0; i < precision; i++) {
		x *= 10;
		buf[n] = ((char) x) + '0';
		n++;
		x = x - ((int) x);
	}
	return n;
}

// void Cseed() {
// 	struct timespec t;
// 	sizeof(struct timespec);
// 	// we have to do this instead of just time(NULL)
// 	// because clock_gettime is a syscall and time is stdlib
// 	if(clock_gettime(CLOCK_REALTIME, &t) == -1) {
// 		perror("clock_gettime");
// 		exit(16);
// 	}
// 	// Seed the randomizer with system time
// 	srand(t.tv_sec);
// }
