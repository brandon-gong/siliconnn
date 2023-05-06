int itoa(char *buf, int x) {
	int n = 0;
	if (x == 0) {
		buf[0] = '0';
		return 1;
	}
	while (x > 0) {
		buf[n] = (x % 10) + '0';
		x /= 10;
		n++;
	}

	for(int i = 0; i < n / 2; i++) {
		char tmp = buf[i];
		buf[i]  = buf[n - i - 1];
		buf[n - i - 1] = tmp;
	}
	
	return n;
}

int dtoa(char *buf, double x, int precision) {
	int n = itoa(buf, (int) x);
	buf[n++] = '.';
	if (x < 0) x *= -1;
	x = x - ((int) x);
	for(int i = 0; i < precision; i++) {
		x *= 10;
		buf[n] = ((char) x) + '0';
		n++;
		x = x - ((int) x);
	}
	return n;
}