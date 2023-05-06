#ifndef _UTIL_H_
#define _UTIL_H_

#include <time.h>
#include <stdlib.h>
#include <stdio.h>

/**
 * This header file defines useful functions used in both nn.c and dataset.c.
 * For now, it is just two functions, itoa and dtoa.
 * 
 * Although these functions are implemented in the C standard library, we
 * will not have access to that in Assembly, so they have to be cooked up from
 * scratch. As such, these are greatly simplified versions of those in the
 * standard library, but "good enough" for our purposes.
 */

/**
 * Converts a POSITIVE integer to a string, putting it into the given buffer.
 * Does not zero-pad.
 * @param buf the buffer to store the stringified int in
 * @param x the int to stringify
 * @returns the length of the stringified int
 */
int Citoa(char *buf, int x);

/**
 * Converts a double value, positive or negative, into a string, putting it in
 * the given buffer. The number of decimal places after the decimal point
 * can be specified by adjusting the precision argument.
 * @param buf the buffer to store the stringified double in
 * @param x the double to stringify
 * @returns the length of the stringified double.
 */
int Cdtoa(char *buf, double x, int precision);

/**
 * Seed the randomizer. Only in the C implementation, going to have to figure
 * out something else for asm.
 */
void Cseed();

#endif
