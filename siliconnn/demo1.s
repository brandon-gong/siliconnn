
demo1:	file format mach-o arm64

Disassembly of section __TEXT,__text:

0000000100001f98 <_main>:
100001f98: ff 03 01 d1 	sub	sp, sp, #64
100001f9c: fd 7b 03 a9 	stp	x29, x30, [sp, #48]
100001fa0: fd c3 00 91 	add	x29, sp, #48
100001fa4: 00 00 00 d0 	adrp	x0, 0x100003000 <_main+0x14>
100001fa8: 00 70 39 91 	add	x0, x0, #3676
100001fac: 61 16 80 52 	mov	w1, #179
100001fb0: c2 01 80 52 	mov	w2, #14
100001fb4: e3 63 00 91 	add	x3, sp, #24
100001fb8: e3 07 00 f9 	str	x3, [sp, #8]
100001fbc: 42 01 00 94 	bl	0x1000024c4 <_Cds_load>
100001fc0: e9 23 40 b9 	ldr	w9, [sp, #32]
100001fc4: e8 03 09 aa 	mov	x8, x9
100001fc8: e9 03 00 91 	mov	x9, sp
100001fcc: 28 01 00 f9 	str	x8, [x9]
100001fd0: 00 00 00 d0 	adrp	x0, 0x100003000 <_main+0x40>
100001fd4: 00 c8 39 91 	add	x0, x0, #3698
100001fd8: 95 07 00 94 	bl	0x100003e2c <_write+0x100003e2c>
100001fdc: e8 0f 40 f9 	ldr	x8, [sp, #24]
100001fe0: 08 01 40 f9 	ldr	x8, [x8]
100001fe4: 08 05 40 f9 	ldr	x8, [x8, #8]
100001fe8: 00 01 40 fd 	ldr	d0, [x8]
100001fec: e8 03 00 91 	mov	x8, sp
100001ff0: 00 01 00 fd 	str	d0, [x8]
100001ff4: 00 00 00 d0 	adrp	x0, 0x100003000 <_main+0x64>
100001ff8: 00 dc 39 91 	add	x0, x0, #3703
100001ffc: e0 0b 00 f9 	str	x0, [sp, #16]
100002000: 8b 07 00 94 	bl	0x100003e2c <_write+0x100003e2c>
100002004: e0 07 40 f9 	ldr	x0, [sp, #8]
100002008: 0d 00 00 94 	bl	0x10000203c <_Cds_destroy>
10000200c: e0 0b 40 f9 	ldr	x0, [sp, #16]
100002010: e8 0f 40 f9 	ldr	x8, [sp, #24]
100002014: 08 01 40 f9 	ldr	x8, [x8]
100002018: 08 05 40 f9 	ldr	x8, [x8, #8]
10000201c: 00 01 40 fd 	ldr	d0, [x8]
100002020: e8 03 00 91 	mov	x8, sp
100002024: 00 01 00 fd 	str	d0, [x8]
100002028: 81 07 00 94 	bl	0x100003e2c <_write+0x100003e2c>
10000202c: 00 00 80 52 	mov	w0, #0
100002030: fd 7b 43 a9 	ldp	x29, x30, [sp, #48]
100002034: ff 03 01 91 	add	sp, sp, #64
100002038: c0 03 5f d6 	ret

000000010000203c <_Cds_destroy>:
10000203c: ff 83 00 d1 	sub	sp, sp, #32
100002040: fd 7b 01 a9 	stp	x29, x30, [sp, #16]
100002044: fd 43 00 91 	add	x29, sp, #16
100002048: e0 07 00 f9 	str	x0, [sp, #8]
10000204c: e8 07 40 f9 	ldr	x8, [sp, #8]
100002050: 00 01 40 f9 	ldr	x0, [x8]
100002054: e8 07 40 f9 	ldr	x8, [sp, #8]
100002058: 08 09 80 b9 	ldrsw	x8, [x8, #8]
10000205c: 01 f1 7d d3 	lsl	x1, x8, #3
100002060: 6a 07 00 94 	bl	0x100003e08 <_write+0x100003e08>
100002064: e0 07 00 b9 	str	w0, [sp, #4]
100002068: e8 07 40 b9 	ldr	w8, [sp, #4]
10000206c: 08 01 00 71 	subs	w8, w8, #0
100002070: e8 17 9f 1a 	cset	w8, eq
100002074: e8 00 00 37 	tbnz	w8, #0, 0x100002090 <_Cds_destroy+0x54>
100002078: 01 00 00 14 	b	0x10000207c <_Cds_destroy+0x40>
10000207c: 00 00 00 b0 	adrp	x0, 0x100003000 <_Cds_destroy+0x44>
100002080: 00 ec 39 91 	add	x0, x0, #3707
100002084: 67 07 00 94 	bl	0x100003e20 <_write+0x100003e20>
100002088: 00 01 80 52 	mov	w0, #8
10000208c: 53 07 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
100002090: fd 7b 41 a9 	ldp	x29, x30, [sp, #16]
100002094: ff 83 00 91 	add	sp, sp, #32
100002098: c0 03 5f d6 	ret

000000010000209c <_Cds_deep_destroy>:
10000209c: ff c3 00 d1 	sub	sp, sp, #48
1000020a0: fd 7b 02 a9 	stp	x29, x30, [sp, #32]
1000020a4: fd 83 00 91 	add	x29, sp, #32
1000020a8: a0 83 1f f8 	stur	x0, [x29, #-8]
1000020ac: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000020b0: 08 0d 80 b9 	ldrsw	x8, [x8, #12]
1000020b4: 08 f1 7d d3 	lsl	x8, x8, #3
1000020b8: 08 11 00 91 	add	x8, x8, #4
1000020bc: e8 0b 00 f9 	str	x8, [sp, #16]
1000020c0: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000020c4: 08 09 80 b9 	ldrsw	x8, [x8, #8]
1000020c8: e9 0b 40 f9 	ldr	x9, [sp, #16]
1000020cc: 08 7d 09 9b 	mul	x8, x8, x9
1000020d0: e8 07 00 f9 	str	x8, [sp, #8]
1000020d4: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000020d8: 00 09 40 f9 	ldr	x0, [x8, #16]
1000020dc: e1 07 40 f9 	ldr	x1, [sp, #8]
1000020e0: 4a 07 00 94 	bl	0x100003e08 <_write+0x100003e08>
1000020e4: e0 07 00 b9 	str	w0, [sp, #4]
1000020e8: e8 07 40 b9 	ldr	w8, [sp, #4]
1000020ec: 08 01 00 71 	subs	w8, w8, #0
1000020f0: e8 17 9f 1a 	cset	w8, eq
1000020f4: e8 00 00 37 	tbnz	w8, #0, 0x100002110 <_Cds_deep_destroy+0x74>
1000020f8: 01 00 00 14 	b	0x1000020fc <_Cds_deep_destroy+0x60>
1000020fc: 00 00 00 b0 	adrp	x0, 0x100003000 <_Cds_deep_destroy+0x64>
100002100: 00 34 3a 91 	add	x0, x0, #3725
100002104: 47 07 00 94 	bl	0x100003e20 <_write+0x100003e20>
100002108: 20 01 80 52 	mov	w0, #9
10000210c: 33 07 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
100002110: a0 83 5f f8 	ldur	x0, [x29, #-8]
100002114: ca ff ff 97 	bl	0x10000203c <_Cds_destroy>
100002118: fd 7b 42 a9 	ldp	x29, x30, [sp, #32]
10000211c: ff c3 00 91 	add	sp, sp, #48
100002120: c0 03 5f d6 	ret

0000000100002124 <_C_consume_past_char>:
100002124: ff 83 00 d1 	sub	sp, sp, #32
100002128: e0 0f 00 f9 	str	x0, [sp, #24]
10000212c: e1 0b 00 f9 	str	x1, [sp, #16]
100002130: e2 3f 00 39 	strb	w2, [sp, #15]
100002134: 01 00 00 14 	b	0x100002138 <_C_consume_past_char+0x14>
100002138: e8 0f 40 f9 	ldr	x8, [sp, #24]
10000213c: 08 01 40 f9 	ldr	x8, [x8]
100002140: 08 01 c0 39 	ldrsb	w8, [x8]
100002144: e9 3f c0 39 	ldrsb	w9, [sp, #15]
100002148: 08 01 09 6b 	subs	w8, w8, w9
10000214c: e8 17 9f 1a 	cset	w8, eq
100002150: e8 01 00 37 	tbnz	w8, #0, 0x10000218c <_C_consume_past_char+0x68>
100002154: 01 00 00 14 	b	0x100002158 <_C_consume_past_char+0x34>
100002158: e9 0f 40 f9 	ldr	x9, [sp, #24]
10000215c: 28 01 40 f9 	ldr	x8, [x9]
100002160: 08 05 00 91 	add	x8, x8, #1
100002164: 28 01 00 f9 	str	x8, [x9]
100002168: e8 0f 40 f9 	ldr	x8, [sp, #24]
10000216c: 08 01 40 f9 	ldr	x8, [x8]
100002170: e9 0b 40 f9 	ldr	x9, [sp, #16]
100002174: 08 01 09 eb 	subs	x8, x8, x9
100002178: e8 07 9f 1a 	cset	w8, ne
10000217c: 68 00 00 37 	tbnz	w8, #0, 0x100002188 <_C_consume_past_char+0x64>
100002180: 01 00 00 14 	b	0x100002184 <_C_consume_past_char+0x60>
100002184: 07 00 00 14 	b	0x1000021a0 <_C_consume_past_char+0x7c>
100002188: ec ff ff 17 	b	0x100002138 <_C_consume_past_char+0x14>
10000218c: e9 0f 40 f9 	ldr	x9, [sp, #24]
100002190: 28 01 40 f9 	ldr	x8, [x9]
100002194: 08 05 00 91 	add	x8, x8, #1
100002198: 28 01 00 f9 	str	x8, [x9]
10000219c: 01 00 00 14 	b	0x1000021a0 <_C_consume_past_char+0x7c>
1000021a0: ff 83 00 91 	add	sp, sp, #32
1000021a4: c0 03 5f d6 	ret

00000001000021a8 <_C_parse_int>:
1000021a8: ff 83 00 d1 	sub	sp, sp, #32
1000021ac: e0 0f 00 f9 	str	x0, [sp, #24]
1000021b0: ff 17 00 b9 	str	wzr, [sp, #20]
1000021b4: 28 00 80 52 	mov	w8, #1
1000021b8: e8 13 00 b9 	str	w8, [sp, #16]
1000021bc: e8 0f 40 f9 	ldr	x8, [sp, #24]
1000021c0: 08 01 40 f9 	ldr	x8, [x8]
1000021c4: 08 01 c0 39 	ldrsb	w8, [x8]
1000021c8: 08 b5 00 71 	subs	w8, w8, #45
1000021cc: e8 07 9f 1a 	cset	w8, ne
1000021d0: 28 01 00 37 	tbnz	w8, #0, 0x1000021f4 <_C_parse_int+0x4c>
1000021d4: 01 00 00 14 	b	0x1000021d8 <_C_parse_int+0x30>
1000021d8: 08 00 80 12 	mov	w8, #-1
1000021dc: e8 13 00 b9 	str	w8, [sp, #16]
1000021e0: e9 0f 40 f9 	ldr	x9, [sp, #24]
1000021e4: 28 01 40 f9 	ldr	x8, [x9]
1000021e8: 08 05 00 91 	add	x8, x8, #1
1000021ec: 28 01 00 f9 	str	x8, [x9]
1000021f0: 01 00 00 14 	b	0x1000021f4 <_C_parse_int+0x4c>
1000021f4: 01 00 00 14 	b	0x1000021f8 <_C_parse_int+0x50>
1000021f8: e8 0f 40 f9 	ldr	x8, [sp, #24]
1000021fc: 08 01 40 f9 	ldr	x8, [x8]
100002200: 08 01 c0 39 	ldrsb	w8, [x8]
100002204: 08 c1 00 71 	subs	w8, w8, #48
100002208: e8 a7 9f 1a 	cset	w8, lt
10000220c: 09 00 80 52 	mov	w9, #0
100002210: e9 0f 00 b9 	str	w9, [sp, #12]
100002214: 28 01 00 37 	tbnz	w8, #0, 0x100002238 <_C_parse_int+0x90>
100002218: 01 00 00 14 	b	0x10000221c <_C_parse_int+0x74>
10000221c: e8 0f 40 f9 	ldr	x8, [sp, #24]
100002220: 08 01 40 f9 	ldr	x8, [x8]
100002224: 08 01 c0 39 	ldrsb	w8, [x8]
100002228: 08 e5 00 71 	subs	w8, w8, #57
10000222c: e8 c7 9f 1a 	cset	w8, le
100002230: e8 0f 00 b9 	str	w8, [sp, #12]
100002234: 01 00 00 14 	b	0x100002238 <_C_parse_int+0x90>
100002238: e8 0f 40 b9 	ldr	w8, [sp, #12]
10000223c: 08 02 00 36 	tbz	w8, #0, 0x10000227c <_C_parse_int+0xd4>
100002240: 01 00 00 14 	b	0x100002244 <_C_parse_int+0x9c>
100002244: e8 17 40 b9 	ldr	w8, [sp, #20]
100002248: 49 01 80 52 	mov	w9, #10
10000224c: 08 7d 09 1b 	mul	w8, w8, w9
100002250: e9 0f 40 f9 	ldr	x9, [sp, #24]
100002254: 29 01 40 f9 	ldr	x9, [x9]
100002258: 29 01 c0 39 	ldrsb	w9, [x9]
10000225c: 29 c1 00 71 	subs	w9, w9, #48
100002260: 08 01 09 0b 	add	w8, w8, w9
100002264: e8 17 00 b9 	str	w8, [sp, #20]
100002268: e9 0f 40 f9 	ldr	x9, [sp, #24]
10000226c: 28 01 40 f9 	ldr	x8, [x9]
100002270: 08 05 00 91 	add	x8, x8, #1
100002274: 28 01 00 f9 	str	x8, [x9]
100002278: e0 ff ff 17 	b	0x1000021f8 <_C_parse_int+0x50>
10000227c: e8 13 40 b9 	ldr	w8, [sp, #16]
100002280: e9 17 40 b9 	ldr	w9, [sp, #20]
100002284: 00 7d 09 1b 	mul	w0, w8, w9
100002288: ff 83 00 91 	add	sp, sp, #32
10000228c: c0 03 5f d6 	ret

0000000100002290 <_C_parse_double>:
100002290: ff 83 00 d1 	sub	sp, sp, #32
100002294: e0 0f 00 f9 	str	x0, [sp, #24]
100002298: 00 e4 00 2f 	movi	d0, #0000000000000000
10000229c: e0 0b 00 fd 	str	d0, [sp, #16]
1000022a0: 28 00 80 52 	mov	w8, #1
1000022a4: e8 0f 00 b9 	str	w8, [sp, #12]
1000022a8: ff 0b 00 b9 	str	wzr, [sp, #8]
1000022ac: ff 07 00 b9 	str	wzr, [sp, #4]
1000022b0: e8 0f 40 f9 	ldr	x8, [sp, #24]
1000022b4: 08 01 40 f9 	ldr	x8, [x8]
1000022b8: 08 01 c0 39 	ldrsb	w8, [x8]
1000022bc: 08 b5 00 71 	subs	w8, w8, #45
1000022c0: e8 07 9f 1a 	cset	w8, ne
1000022c4: 28 01 00 37 	tbnz	w8, #0, 0x1000022e8 <_C_parse_double+0x58>
1000022c8: 01 00 00 14 	b	0x1000022cc <_C_parse_double+0x3c>
1000022cc: 08 00 80 12 	mov	w8, #-1
1000022d0: e8 0f 00 b9 	str	w8, [sp, #12]
1000022d4: e9 0f 40 f9 	ldr	x9, [sp, #24]
1000022d8: 28 01 40 f9 	ldr	x8, [x9]
1000022dc: 08 05 00 91 	add	x8, x8, #1
1000022e0: 28 01 00 f9 	str	x8, [x9]
1000022e4: 01 00 00 14 	b	0x1000022e8 <_C_parse_double+0x58>
1000022e8: 01 00 00 14 	b	0x1000022ec <_C_parse_double+0x5c>
1000022ec: e8 0f 40 f9 	ldr	x8, [sp, #24]
1000022f0: 08 01 40 f9 	ldr	x8, [x8]
1000022f4: 08 01 c0 39 	ldrsb	w8, [x8]
1000022f8: 08 b9 00 71 	subs	w8, w8, #46
1000022fc: e8 07 9f 1a 	cset	w8, ne
100002300: 88 01 00 37 	tbnz	w8, #0, 0x100002330 <_C_parse_double+0xa0>
100002304: 01 00 00 14 	b	0x100002308 <_C_parse_double+0x78>
100002308: e8 0b 40 b9 	ldr	w8, [sp, #8]
10000230c: 08 01 00 71 	subs	w8, w8, #0
100002310: e8 17 9f 1a 	cset	w8, eq
100002314: 68 00 00 37 	tbnz	w8, #0, 0x100002320 <_C_parse_double+0x90>
100002318: 01 00 00 14 	b	0x10000231c <_C_parse_double+0x8c>
10000231c: 28 00 00 14 	b	0x1000023bc <_C_parse_double+0x12c>
100002320: 28 00 80 52 	mov	w8, #1
100002324: e8 0b 00 b9 	str	w8, [sp, #8]
100002328: 01 00 00 14 	b	0x10000232c <_C_parse_double+0x9c>
10000232c: 1f 00 00 14 	b	0x1000023a8 <_C_parse_double+0x118>
100002330: e8 0f 40 f9 	ldr	x8, [sp, #24]
100002334: 08 01 40 f9 	ldr	x8, [x8]
100002338: 08 01 c0 39 	ldrsb	w8, [x8]
10000233c: 08 c1 00 71 	subs	w8, w8, #48
100002340: e8 a7 9f 1a 	cset	w8, lt
100002344: e8 02 00 37 	tbnz	w8, #0, 0x1000023a0 <_C_parse_double+0x110>
100002348: 01 00 00 14 	b	0x10000234c <_C_parse_double+0xbc>
10000234c: e8 0f 40 f9 	ldr	x8, [sp, #24]
100002350: 08 01 40 f9 	ldr	x8, [x8]
100002354: 08 01 c0 39 	ldrsb	w8, [x8]
100002358: 08 e5 00 71 	subs	w8, w8, #57
10000235c: e8 d7 9f 1a 	cset	w8, gt
100002360: 08 02 00 37 	tbnz	w8, #0, 0x1000023a0 <_C_parse_double+0x110>
100002364: 01 00 00 14 	b	0x100002368 <_C_parse_double+0xd8>
100002368: e0 0b 40 fd 	ldr	d0, [sp, #16]
10000236c: e8 0f 40 f9 	ldr	x8, [sp, #24]
100002370: 08 01 40 f9 	ldr	x8, [x8]
100002374: 08 01 c0 39 	ldrsb	w8, [x8]
100002378: 08 c1 00 71 	subs	w8, w8, #48
10000237c: 02 01 62 1e 	scvtf	d2, w8
100002380: 01 90 64 1e 	fmov	d1, #10.00000000
100002384: 00 08 41 1f 	fmadd	d0, d0, d1, d2
100002388: e0 0b 00 fd 	str	d0, [sp, #16]
10000238c: e9 0b 40 b9 	ldr	w9, [sp, #8]
100002390: e8 07 40 b9 	ldr	w8, [sp, #4]
100002394: 08 01 09 0b 	add	w8, w8, w9
100002398: e8 07 00 b9 	str	w8, [sp, #4]
10000239c: 02 00 00 14 	b	0x1000023a4 <_C_parse_double+0x114>
1000023a0: 07 00 00 14 	b	0x1000023bc <_C_parse_double+0x12c>
1000023a4: 01 00 00 14 	b	0x1000023a8 <_C_parse_double+0x118>
1000023a8: e9 0f 40 f9 	ldr	x9, [sp, #24]
1000023ac: 28 01 40 f9 	ldr	x8, [x9]
1000023b0: 08 05 00 91 	add	x8, x8, #1
1000023b4: 28 01 00 f9 	str	x8, [x9]
1000023b8: cd ff ff 17 	b	0x1000022ec <_C_parse_double+0x5c>
1000023bc: 01 00 00 14 	b	0x1000023c0 <_C_parse_double+0x130>
1000023c0: e8 07 40 b9 	ldr	w8, [sp, #4]
1000023c4: 09 05 00 71 	subs	w9, w8, #1
1000023c8: e9 07 00 b9 	str	w9, [sp, #4]
1000023cc: 08 01 00 71 	subs	w8, w8, #0
1000023d0: e8 17 9f 1a 	cset	w8, eq
1000023d4: e8 00 00 37 	tbnz	w8, #0, 0x1000023f0 <_C_parse_double+0x160>
1000023d8: 01 00 00 14 	b	0x1000023dc <_C_parse_double+0x14c>
1000023dc: e0 0b 40 fd 	ldr	d0, [sp, #16]
1000023e0: 01 90 64 1e 	fmov	d1, #10.00000000
1000023e4: 00 18 61 1e 	fdiv	d0, d0, d1
1000023e8: e0 0b 00 fd 	str	d0, [sp, #16]
1000023ec: f5 ff ff 17 	b	0x1000023c0 <_C_parse_double+0x130>
1000023f0: e1 0f 40 bd 	ldr	s1, [sp, #12]
1000023f4: 20 40 20 1e 	fmov	s0, s1
1000023f8: 00 a4 20 0f 	sshll.2d	v0, v0, #0
1000023fc: 00 d8 61 5e 	scvtf	d0, d0
100002400: e1 0b 40 fd 	ldr	d1, [sp, #16]
100002404: 00 08 61 1e 	fmul	d0, d0, d1
100002408: ff 83 00 91 	add	sp, sp, #32
10000240c: c0 03 5f d6 	ret

0000000100002410 <_C_parse_data>:
100002410: ff 03 01 d1 	sub	sp, sp, #64
100002414: fd 7b 03 a9 	stp	x29, x30, [sp, #48]
100002418: fd c3 00 91 	add	x29, sp, #48
10000241c: a0 83 1f f8 	stur	x0, [x29, #-8]
100002420: a1 03 1f f8 	stur	x1, [x29, #-16]
100002424: a2 c3 1e b8 	stur	w2, [x29, #-20]
100002428: e3 0b 00 f9 	str	x3, [sp, #16]
10000242c: a0 83 5f f8 	ldur	x0, [x29, #-8]
100002430: 5e ff ff 97 	bl	0x1000021a8 <_C_parse_int>
100002434: a8 03 5f f8 	ldur	x8, [x29, #-16]
100002438: 00 01 00 b9 	str	w0, [x8]
10000243c: a8 03 5f f8 	ldur	x8, [x29, #-16]
100002440: 08 41 00 91 	add	x8, x8, #16
100002444: a9 03 5f f8 	ldur	x9, [x29, #-16]
100002448: 28 05 00 f9 	str	x8, [x9, #8]
10000244c: ff 0f 00 b9 	str	wzr, [sp, #12]
100002450: 01 00 00 14 	b	0x100002454 <_C_parse_data+0x44>
100002454: e8 0f 40 b9 	ldr	w8, [sp, #12]
100002458: a9 c3 5e b8 	ldur	w9, [x29, #-20]
10000245c: 08 01 09 6b 	subs	w8, w8, w9
100002460: e8 b7 9f 1a 	cset	w8, ge
100002464: 28 02 00 37 	tbnz	w8, #0, 0x1000024a8 <_C_parse_data+0x98>
100002468: 01 00 00 14 	b	0x10000246c <_C_parse_data+0x5c>
10000246c: a0 83 5f f8 	ldur	x0, [x29, #-8]
100002470: e1 0b 40 f9 	ldr	x1, [sp, #16]
100002474: 82 05 80 52 	mov	w2, #44
100002478: 2b ff ff 97 	bl	0x100002124 <_C_consume_past_char>
10000247c: a0 83 5f f8 	ldur	x0, [x29, #-8]
100002480: 84 ff ff 97 	bl	0x100002290 <_C_parse_double>
100002484: a8 03 5f f8 	ldur	x8, [x29, #-16]
100002488: 08 05 40 f9 	ldr	x8, [x8, #8]
10000248c: e9 0f 80 b9 	ldrsw	x9, [sp, #12]
100002490: 00 79 29 fc 	str	d0, [x8, x9, lsl #3]
100002494: 01 00 00 14 	b	0x100002498 <_C_parse_data+0x88>
100002498: e8 0f 40 b9 	ldr	w8, [sp, #12]
10000249c: 08 05 00 11 	add	w8, w8, #1
1000024a0: e8 0f 00 b9 	str	w8, [sp, #12]
1000024a4: ec ff ff 17 	b	0x100002454 <_C_parse_data+0x44>
1000024a8: a0 83 5f f8 	ldur	x0, [x29, #-8]
1000024ac: e1 0b 40 f9 	ldr	x1, [sp, #16]
1000024b0: 42 01 80 52 	mov	w2, #10
1000024b4: 1c ff ff 97 	bl	0x100002124 <_C_consume_past_char>
1000024b8: fd 7b 43 a9 	ldp	x29, x30, [sp, #48]
1000024bc: ff 03 01 91 	add	sp, sp, #64
1000024c0: c0 03 5f d6 	ret

00000001000024c4 <_Cds_load>:
1000024c4: ff 83 04 d1 	sub	sp, sp, #288
1000024c8: fc 6f 10 a9 	stp	x28, x27, [sp, #256]
1000024cc: fd 7b 11 a9 	stp	x29, x30, [sp, #272]
1000024d0: fd 43 04 91 	add	x29, sp, #272
1000024d4: a0 83 1e f8 	stur	x0, [x29, #-24]
1000024d8: a1 43 1e b8 	stur	w1, [x29, #-28]
1000024dc: a2 03 1e b8 	stur	w2, [x29, #-32]
1000024e0: a3 83 1d f8 	stur	x3, [x29, #-40]
1000024e4: a8 43 5e b8 	ldur	w8, [x29, #-28]
1000024e8: 08 05 00 71 	subs	w8, w8, #1
1000024ec: a9 83 5d f8 	ldur	x9, [x29, #-40]
1000024f0: 28 09 00 b9 	str	w8, [x9, #8]
1000024f4: a8 03 5e b8 	ldur	w8, [x29, #-32]
1000024f8: 08 05 00 71 	subs	w8, w8, #1
1000024fc: a9 83 5d f8 	ldur	x9, [x29, #-40]
100002500: 28 0d 00 b9 	str	w8, [x9, #12]
100002504: a8 83 5d f8 	ldur	x8, [x29, #-40]
100002508: 08 0d 80 b9 	ldrsw	x8, [x8, #12]
10000250c: 08 f1 7d d3 	lsl	x8, x8, #3
100002510: 08 41 00 91 	add	x8, x8, #16
100002514: a8 03 1d f8 	stur	x8, [x29, #-48]
100002518: a8 83 5d f8 	ldur	x8, [x29, #-40]
10000251c: 08 09 80 b9 	ldrsw	x8, [x8, #8]
100002520: a9 03 5d f8 	ldur	x9, [x29, #-48]
100002524: 08 7d 09 9b 	mul	x8, x8, x9
100002528: a8 83 1c f8 	stur	x8, [x29, #-56]
10000252c: a1 83 5c f8 	ldur	x1, [x29, #-56]
100002530: 00 00 80 d2 	mov	x0, #0
100002534: 62 00 80 52 	mov	w2, #3
100002538: 23 00 82 52 	mov	w3, #4097
10000253c: 04 00 80 12 	mov	w4, #-1
100002540: 05 00 80 d2 	mov	x5, #0
100002544: 2e 06 00 94 	bl	0x100003dfc <_write+0x100003dfc>
100002548: a0 03 1c f8 	stur	x0, [x29, #-64]
10000254c: a8 03 5c f8 	ldur	x8, [x29, #-64]
100002550: 08 05 00 b1 	adds	x8, x8, #1
100002554: e8 07 9f 1a 	cset	w8, ne
100002558: e8 00 00 37 	tbnz	w8, #0, 0x100002574 <_Cds_load+0xb0>
10000255c: 01 00 00 14 	b	0x100002560 <_Cds_load+0x9c>
100002560: 00 00 00 b0 	adrp	x0, 0x100003000 <_Cds_load+0xa0>
100002564: 00 90 3a 91 	add	x0, x0, #3748
100002568: 31 06 00 94 	bl	0x100003e2c <_write+0x100003e2c>
10000256c: 40 01 80 52 	mov	w0, #10
100002570: 1a 06 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
100002574: a8 03 5c f8 	ldur	x8, [x29, #-64]
100002578: a9 83 5d f8 	ldur	x9, [x29, #-40]
10000257c: 28 09 00 f9 	str	x8, [x9, #16]
100002580: a0 83 5e f8 	ldur	x0, [x29, #-24]
100002584: 01 00 80 52 	mov	w1, #0
100002588: 23 06 00 94 	bl	0x100003e14 <_write+0x100003e14>
10000258c: a0 c3 1b b8 	stur	w0, [x29, #-68]
100002590: a8 c3 5b b8 	ldur	w8, [x29, #-68]
100002594: 08 01 00 71 	subs	w8, w8, #0
100002598: e8 b7 9f 1a 	cset	w8, ge
10000259c: e8 00 00 37 	tbnz	w8, #0, 0x1000025b8 <_Cds_load+0xf4>
1000025a0: 01 00 00 14 	b	0x1000025a4 <_Cds_load+0xe0>
1000025a4: 00 00 00 b0 	adrp	x0, 0x100003000 <_Cds_load+0xe4>
1000025a8: 00 e4 3a 91 	add	x0, x0, #3769
1000025ac: 1d 06 00 94 	bl	0x100003e20 <_write+0x100003e20>
1000025b0: 60 01 80 52 	mov	w0, #11
1000025b4: 09 06 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
1000025b8: a0 c3 5b b8 	ldur	w0, [x29, #-68]
1000025bc: e1 e3 00 91 	add	x1, sp, #56
1000025c0: 0c 06 00 94 	bl	0x100003df0 <_write+0x100003df0>
1000025c4: e0 37 00 b9 	str	w0, [sp, #52]
1000025c8: e8 37 40 b9 	ldr	w8, [sp, #52]
1000025cc: 08 01 00 71 	subs	w8, w8, #0
1000025d0: e8 b7 9f 1a 	cset	w8, ge
1000025d4: e8 00 00 37 	tbnz	w8, #0, 0x1000025f0 <_Cds_load+0x12c>
1000025d8: 01 00 00 14 	b	0x1000025dc <_Cds_load+0x118>
1000025dc: 00 00 00 b0 	adrp	x0, 0x100003000 <_Cds_load+0x11c>
1000025e0: 00 f8 3a 91 	add	x0, x0, #3774
1000025e4: 0f 06 00 94 	bl	0x100003e20 <_write+0x100003e20>
1000025e8: 80 01 80 52 	mov	w0, #12
1000025ec: fb 05 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
1000025f0: e1 4f 40 f9 	ldr	x1, [sp, #152]
1000025f4: a4 c3 5b b8 	ldur	w4, [x29, #-68]
1000025f8: 00 00 80 d2 	mov	x0, #0
1000025fc: 23 00 80 52 	mov	w3, #1
100002600: e2 03 03 aa 	mov	x2, x3
100002604: 05 00 80 d2 	mov	x5, #0
100002608: fd 05 00 94 	bl	0x100003dfc <_write+0x100003dfc>
10000260c: e0 17 00 f9 	str	x0, [sp, #40]
100002610: e8 17 40 f9 	ldr	x8, [sp, #40]
100002614: 08 05 00 b1 	adds	x8, x8, #1
100002618: e8 07 9f 1a 	cset	w8, ne
10000261c: e8 00 00 37 	tbnz	w8, #0, 0x100002638 <_Cds_load+0x174>
100002620: 01 00 00 14 	b	0x100002624 <_Cds_load+0x160>
100002624: 00 00 00 b0 	adrp	x0, 0x100003000 <_Cds_load+0x164>
100002628: 00 10 3b 91 	add	x0, x0, #3780
10000262c: 00 06 00 94 	bl	0x100003e2c <_write+0x100003e2c>
100002630: a0 01 80 52 	mov	w0, #13
100002634: e9 05 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
100002638: a0 c3 5b b8 	ldur	w0, [x29, #-68]
10000263c: e4 05 00 94 	bl	0x100003dcc <_write+0x100003dcc>
100002640: a8 83 5d f8 	ldur	x8, [x29, #-40]
100002644: 09 09 80 b9 	ldrsw	x9, [x8, #8]
100002648: 08 01 80 d2 	mov	x8, #8
10000264c: 01 7d 09 9b 	mul	x1, x8, x9
100002650: 00 00 80 d2 	mov	x0, #0
100002654: 62 00 80 52 	mov	w2, #3
100002658: 23 00 82 52 	mov	w3, #4097
10000265c: 04 00 80 12 	mov	w4, #-1
100002660: 05 00 80 d2 	mov	x5, #0
100002664: e6 05 00 94 	bl	0x100003dfc <_write+0x100003dfc>
100002668: a8 83 5d f8 	ldur	x8, [x29, #-40]
10000266c: 00 01 00 f9 	str	x0, [x8]
100002670: a8 83 5d f8 	ldur	x8, [x29, #-40]
100002674: 08 01 40 f9 	ldr	x8, [x8]
100002678: 08 05 00 b1 	adds	x8, x8, #1
10000267c: e8 07 9f 1a 	cset	w8, ne
100002680: e8 00 00 37 	tbnz	w8, #0, 0x10000269c <_Cds_load+0x1d8>
100002684: 01 00 00 14 	b	0x100002688 <_Cds_load+0x1c4>
100002688: 00 00 00 b0 	adrp	x0, 0x100003000 <_Cds_load+0x1c8>
10000268c: 00 64 3b 91 	add	x0, x0, #3801
100002690: e7 05 00 94 	bl	0x100003e2c <_write+0x100003e2c>
100002694: c0 01 80 52 	mov	w0, #14
100002698: d0 05 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
10000269c: e8 17 40 f9 	ldr	x8, [sp, #40]
1000026a0: e0 83 00 91 	add	x0, sp, #32
1000026a4: e8 13 00 f9 	str	x8, [sp, #32]
1000026a8: e8 17 40 f9 	ldr	x8, [sp, #40]
1000026ac: e9 4f 40 f9 	ldr	x9, [sp, #152]
1000026b0: 08 01 09 8b 	add	x8, x8, x9
1000026b4: e8 0f 00 f9 	str	x8, [sp, #24]
1000026b8: e1 0f 40 f9 	ldr	x1, [sp, #24]
1000026bc: 42 01 80 52 	mov	w2, #10
1000026c0: 99 fe ff 97 	bl	0x100002124 <_C_consume_past_char>
1000026c4: ff 17 00 b9 	str	wzr, [sp, #20]
1000026c8: 01 00 00 14 	b	0x1000026cc <_Cds_load+0x208>
1000026cc: e8 17 40 b9 	ldr	w8, [sp, #20]
1000026d0: a9 83 5d f8 	ldur	x9, [x29, #-40]
1000026d4: 29 09 40 b9 	ldr	w9, [x9, #8]
1000026d8: 08 01 09 6b 	subs	w8, w8, w9
1000026dc: e8 b7 9f 1a 	cset	w8, ge
1000026e0: 08 03 00 37 	tbnz	w8, #0, 0x100002740 <_Cds_load+0x27c>
1000026e4: 01 00 00 14 	b	0x1000026e8 <_Cds_load+0x224>
1000026e8: a8 03 5c f8 	ldur	x8, [x29, #-64]
1000026ec: e9 17 80 b9 	ldrsw	x9, [sp, #20]
1000026f0: aa 03 5d f8 	ldur	x10, [x29, #-48]
1000026f4: 29 7d 0a 9b 	mul	x9, x9, x10
1000026f8: 08 01 09 8b 	add	x8, x8, x9
1000026fc: e8 07 00 f9 	str	x8, [sp, #8]
100002700: e8 07 40 f9 	ldr	x8, [sp, #8]
100002704: a9 83 5d f8 	ldur	x9, [x29, #-40]
100002708: 29 01 40 f9 	ldr	x9, [x9]
10000270c: ea 17 80 b9 	ldrsw	x10, [sp, #20]
100002710: 28 79 2a f8 	str	x8, [x9, x10, lsl #3]
100002714: e1 07 40 f9 	ldr	x1, [sp, #8]
100002718: a8 83 5d f8 	ldur	x8, [x29, #-40]
10000271c: 02 0d 40 b9 	ldr	w2, [x8, #12]
100002720: e3 0f 40 f9 	ldr	x3, [sp, #24]
100002724: e0 83 00 91 	add	x0, sp, #32
100002728: 3a ff ff 97 	bl	0x100002410 <_C_parse_data>
10000272c: 01 00 00 14 	b	0x100002730 <_Cds_load+0x26c>
100002730: e8 17 40 b9 	ldr	w8, [sp, #20]
100002734: 08 05 00 11 	add	w8, w8, #1
100002738: e8 17 00 b9 	str	w8, [sp, #20]
10000273c: e4 ff ff 17 	b	0x1000026cc <_Cds_load+0x208>
100002740: e0 17 40 f9 	ldr	x0, [sp, #40]
100002744: e1 4f 40 f9 	ldr	x1, [sp, #152]
100002748: b0 05 00 94 	bl	0x100003e08 <_write+0x100003e08>
10000274c: e0 37 00 b9 	str	w0, [sp, #52]
100002750: e8 37 40 b9 	ldr	w8, [sp, #52]
100002754: 08 01 00 71 	subs	w8, w8, #0
100002758: e8 17 9f 1a 	cset	w8, eq
10000275c: e8 00 00 37 	tbnz	w8, #0, 0x100002778 <_Cds_load+0x2b4>
100002760: 01 00 00 14 	b	0x100002764 <_Cds_load+0x2a0>
100002764: 00 00 00 b0 	adrp	x0, 0x100003000 <_Cds_load+0x2a4>
100002768: 00 c8 3b 91 	add	x0, x0, #3826
10000276c: ad 05 00 94 	bl	0x100003e20 <_write+0x100003e20>
100002770: e0 01 80 52 	mov	w0, #15
100002774: 99 05 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
100002778: fd 7b 51 a9 	ldp	x29, x30, [sp, #272]
10000277c: fc 6f 50 a9 	ldp	x28, x27, [sp, #256]
100002780: ff 83 04 91 	add	sp, sp, #288
100002784: c0 03 5f d6 	ret

0000000100002788 <_Cds_shuffle>:
100002788: ff c3 00 d1 	sub	sp, sp, #48
10000278c: fd 7b 02 a9 	stp	x29, x30, [sp, #32]
100002790: fd 83 00 91 	add	x29, sp, #32
100002794: a0 83 1f f8 	stur	x0, [x29, #-8]
100002798: a8 83 5f f8 	ldur	x8, [x29, #-8]
10000279c: 08 09 40 b9 	ldr	w8, [x8, #8]
1000027a0: 08 05 00 71 	subs	w8, w8, #1
1000027a4: a8 43 1f b8 	stur	w8, [x29, #-12]
1000027a8: 01 00 00 14 	b	0x1000027ac <_Cds_shuffle+0x24>
1000027ac: a8 43 5f b8 	ldur	w8, [x29, #-12]
1000027b0: 08 01 00 71 	subs	w8, w8, #0
1000027b4: e8 c7 9f 1a 	cset	w8, le
1000027b8: 08 04 00 37 	tbnz	w8, #0, 0x100002838 <_Cds_shuffle+0xb0>
1000027bc: 01 00 00 14 	b	0x1000027c0 <_Cds_shuffle+0x38>
1000027c0: 9e 05 00 94 	bl	0x100003e38 <_write+0x100003e38>
1000027c4: a8 43 5f b8 	ldur	w8, [x29, #-12]
1000027c8: 09 05 00 11 	add	w9, w8, #1
1000027cc: 08 0c c9 1a 	sdiv	w8, w0, w9
1000027d0: 08 7d 09 1b 	mul	w8, w8, w9
1000027d4: 08 00 08 6b 	subs	w8, w0, w8
1000027d8: e8 13 00 b9 	str	w8, [sp, #16]
1000027dc: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000027e0: 08 01 40 f9 	ldr	x8, [x8]
1000027e4: e9 13 80 b9 	ldrsw	x9, [sp, #16]
1000027e8: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
1000027ec: e8 07 00 f9 	str	x8, [sp, #8]
1000027f0: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000027f4: 08 01 40 f9 	ldr	x8, [x8]
1000027f8: a9 43 9f b8 	ldursw	x9, [x29, #-12]
1000027fc: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
100002800: a9 83 5f f8 	ldur	x9, [x29, #-8]
100002804: 29 01 40 f9 	ldr	x9, [x9]
100002808: ea 13 80 b9 	ldrsw	x10, [sp, #16]
10000280c: 28 79 2a f8 	str	x8, [x9, x10, lsl #3]
100002810: e8 07 40 f9 	ldr	x8, [sp, #8]
100002814: a9 83 5f f8 	ldur	x9, [x29, #-8]
100002818: 29 01 40 f9 	ldr	x9, [x9]
10000281c: aa 43 9f b8 	ldursw	x10, [x29, #-12]
100002820: 28 79 2a f8 	str	x8, [x9, x10, lsl #3]
100002824: 01 00 00 14 	b	0x100002828 <_Cds_shuffle+0xa0>
100002828: a8 43 5f b8 	ldur	w8, [x29, #-12]
10000282c: 08 05 00 71 	subs	w8, w8, #1
100002830: a8 43 1f b8 	stur	w8, [x29, #-12]
100002834: de ff ff 17 	b	0x1000027ac <_Cds_shuffle+0x24>
100002838: fd 7b 42 a9 	ldp	x29, x30, [sp, #32]
10000283c: ff c3 00 91 	add	sp, sp, #48
100002840: c0 03 5f d6 	ret

0000000100002844 <_Cds_train_test_split>:
100002844: ff c3 01 d1 	sub	sp, sp, #112
100002848: fd 7b 06 a9 	stp	x29, x30, [sp, #96]
10000284c: fd 83 01 91 	add	x29, sp, #96
100002850: a0 83 1f f8 	stur	x0, [x29, #-8]
100002854: a1 03 1f f8 	stur	x1, [x29, #-16]
100002858: a2 83 1e f8 	stur	x2, [x29, #-24]
10000285c: a0 03 1e fc 	stur	d0, [x29, #-32]
100002860: a0 03 5e fc 	ldur	d0, [x29, #-32]
100002864: 08 20 60 1e 	fcmp	d0, #0.0
100002868: e8 47 9f 1a 	cset	w8, pl
10000286c: a8 00 00 37 	tbnz	w8, #0, 0x100002880 <_Cds_train_test_split+0x3c>
100002870: 01 00 00 14 	b	0x100002874 <_Cds_train_test_split+0x30>
100002874: 00 e4 00 2f 	movi	d0, #0000000000000000
100002878: a0 03 1e fc 	stur	d0, [x29, #-32]
10000287c: 01 00 00 14 	b	0x100002880 <_Cds_train_test_split+0x3c>
100002880: a0 03 5e fc 	ldur	d0, [x29, #-32]
100002884: 01 10 6e 1e 	fmov	d1, #1.00000000
100002888: 00 20 61 1e 	fcmp	d0, d1
10000288c: e8 c7 9f 1a 	cset	w8, le
100002890: a8 00 00 37 	tbnz	w8, #0, 0x1000028a4 <_Cds_train_test_split+0x60>
100002894: 01 00 00 14 	b	0x100002898 <_Cds_train_test_split+0x54>
100002898: 00 10 6e 1e 	fmov	d0, #1.00000000
10000289c: a0 03 1e fc 	stur	d0, [x29, #-32]
1000028a0: 01 00 00 14 	b	0x1000028a4 <_Cds_train_test_split+0x60>
1000028a4: a0 03 5e fc 	ldur	d0, [x29, #-32]
1000028a8: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000028ac: 02 09 40 bd 	ldr	s2, [x8, #8]
1000028b0: 41 40 20 1e 	fmov	s1, s2
1000028b4: 21 a4 20 0f 	sshll.2d	v1, v1, #0
1000028b8: 21 d8 61 5e 	scvtf	d1, d1
1000028bc: 00 08 61 1e 	fmul	d0, d0, d1
1000028c0: 08 00 78 1e 	fcvtzs	w8, d0
1000028c4: a8 c3 1d b8 	stur	w8, [x29, #-36]
1000028c8: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000028cc: 08 09 40 b9 	ldr	w8, [x8, #8]
1000028d0: a9 c3 5d b8 	ldur	w9, [x29, #-36]
1000028d4: 08 01 09 6b 	subs	w8, w8, w9
1000028d8: a8 83 1d b8 	stur	w8, [x29, #-40]
1000028dc: a8 c3 5d b8 	ldur	w8, [x29, #-36]
1000028e0: a9 83 5e f8 	ldur	x9, [x29, #-24]
1000028e4: 28 09 00 b9 	str	w8, [x9, #8]
1000028e8: a8 83 5d b8 	ldur	w8, [x29, #-40]
1000028ec: a9 03 5f f8 	ldur	x9, [x29, #-16]
1000028f0: 28 09 00 b9 	str	w8, [x9, #8]
1000028f4: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000028f8: 08 0d 40 b9 	ldr	w8, [x8, #12]
1000028fc: a9 83 5e f8 	ldur	x9, [x29, #-24]
100002900: 28 0d 00 b9 	str	w8, [x9, #12]
100002904: a8 83 5f f8 	ldur	x8, [x29, #-8]
100002908: 08 0d 40 b9 	ldr	w8, [x8, #12]
10000290c: a9 03 5f f8 	ldur	x9, [x29, #-16]
100002910: 28 0d 00 b9 	str	w8, [x9, #12]
100002914: a8 83 5e f8 	ldur	x8, [x29, #-24]
100002918: 00 00 80 d2 	mov	x0, #0
10000291c: e0 17 00 f9 	str	x0, [sp, #40]
100002920: 1f 09 00 f9 	str	xzr, [x8, #16]
100002924: a8 03 5f f8 	ldur	x8, [x29, #-16]
100002928: 1f 09 00 f9 	str	xzr, [x8, #16]
10000292c: a9 c3 9d b8 	ldursw	x9, [x29, #-36]
100002930: 08 01 80 d2 	mov	x8, #8
100002934: e8 07 00 f9 	str	x8, [sp, #8]
100002938: 01 7d 09 9b 	mul	x1, x8, x9
10000293c: 62 00 80 52 	mov	w2, #3
100002940: e2 17 00 b9 	str	w2, [sp, #20]
100002944: 23 00 82 52 	mov	w3, #4097
100002948: e3 1b 00 b9 	str	w3, [sp, #24]
10000294c: 04 00 80 12 	mov	w4, #-1
100002950: e4 1f 00 b9 	str	w4, [sp, #28]
100002954: 05 00 80 d2 	mov	x5, #0
100002958: e5 13 00 f9 	str	x5, [sp, #32]
10000295c: 28 05 00 94 	bl	0x100003dfc <_write+0x100003dfc>
100002960: e8 07 40 f9 	ldr	x8, [sp, #8]
100002964: e2 17 40 b9 	ldr	w2, [sp, #20]
100002968: e3 1b 40 b9 	ldr	w3, [sp, #24]
10000296c: e4 1f 40 b9 	ldr	w4, [sp, #28]
100002970: e5 13 40 f9 	ldr	x5, [sp, #32]
100002974: e9 03 00 aa 	mov	x9, x0
100002978: e0 17 40 f9 	ldr	x0, [sp, #40]
10000297c: aa 83 5e f8 	ldur	x10, [x29, #-24]
100002980: 49 01 00 f9 	str	x9, [x10]
100002984: a9 83 9d b8 	ldursw	x9, [x29, #-40]
100002988: 01 7d 09 9b 	mul	x1, x8, x9
10000298c: 1c 05 00 94 	bl	0x100003dfc <_write+0x100003dfc>
100002990: a8 03 5f f8 	ldur	x8, [x29, #-16]
100002994: 00 01 00 f9 	str	x0, [x8]
100002998: bf 43 1d b8 	stur	wzr, [x29, #-44]
10000299c: 01 00 00 14 	b	0x1000029a0 <_Cds_train_test_split+0x15c>
1000029a0: a8 43 5d b8 	ldur	w8, [x29, #-44]
1000029a4: a9 c3 5d b8 	ldur	w9, [x29, #-36]
1000029a8: 08 01 09 6b 	subs	w8, w8, w9
1000029ac: e8 b7 9f 1a 	cset	w8, ge
1000029b0: e8 01 00 37 	tbnz	w8, #0, 0x1000029ec <_Cds_train_test_split+0x1a8>
1000029b4: 01 00 00 14 	b	0x1000029b8 <_Cds_train_test_split+0x174>
1000029b8: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000029bc: 08 01 40 f9 	ldr	x8, [x8]
1000029c0: a9 43 9d b8 	ldursw	x9, [x29, #-44]
1000029c4: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
1000029c8: a9 83 5e f8 	ldur	x9, [x29, #-24]
1000029cc: 29 01 40 f9 	ldr	x9, [x9]
1000029d0: aa 43 9d b8 	ldursw	x10, [x29, #-44]
1000029d4: 28 79 2a f8 	str	x8, [x9, x10, lsl #3]
1000029d8: 01 00 00 14 	b	0x1000029dc <_Cds_train_test_split+0x198>
1000029dc: a8 43 5d b8 	ldur	w8, [x29, #-44]
1000029e0: 08 05 00 11 	add	w8, w8, #1
1000029e4: a8 43 1d b8 	stur	w8, [x29, #-44]
1000029e8: ee ff ff 17 	b	0x1000029a0 <_Cds_train_test_split+0x15c>
1000029ec: a8 c3 5d b8 	ldur	w8, [x29, #-36]
1000029f0: e8 33 00 b9 	str	w8, [sp, #48]
1000029f4: 01 00 00 14 	b	0x1000029f8 <_Cds_train_test_split+0x1b4>
1000029f8: e8 33 40 b9 	ldr	w8, [sp, #48]
1000029fc: a9 83 5f f8 	ldur	x9, [x29, #-8]
100002a00: 29 09 40 b9 	ldr	w9, [x9, #8]
100002a04: 08 01 09 6b 	subs	w8, w8, w9
100002a08: e8 b7 9f 1a 	cset	w8, ge
100002a0c: 28 02 00 37 	tbnz	w8, #0, 0x100002a50 <_Cds_train_test_split+0x20c>
100002a10: 01 00 00 14 	b	0x100002a14 <_Cds_train_test_split+0x1d0>
100002a14: a8 83 5f f8 	ldur	x8, [x29, #-8]
100002a18: 08 01 40 f9 	ldr	x8, [x8]
100002a1c: e9 33 80 b9 	ldrsw	x9, [sp, #48]
100002a20: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
100002a24: a9 03 5f f8 	ldur	x9, [x29, #-16]
100002a28: 29 01 40 f9 	ldr	x9, [x9]
100002a2c: ea 33 40 b9 	ldr	w10, [sp, #48]
100002a30: ab c3 5d b8 	ldur	w11, [x29, #-36]
100002a34: 4a 01 0b 6b 	subs	w10, w10, w11
100002a38: 28 d9 2a f8 	str	x8, [x9, w10, sxtw #3]
100002a3c: 01 00 00 14 	b	0x100002a40 <_Cds_train_test_split+0x1fc>
100002a40: e8 33 40 b9 	ldr	w8, [sp, #48]
100002a44: 08 05 00 11 	add	w8, w8, #1
100002a48: e8 33 00 b9 	str	w8, [sp, #48]
100002a4c: eb ff ff 17 	b	0x1000029f8 <_Cds_train_test_split+0x1b4>
100002a50: fd 7b 46 a9 	ldp	x29, x30, [sp, #96]
100002a54: ff c3 01 91 	add	sp, sp, #112
100002a58: c0 03 5f d6 	ret

0000000100002a5c <_Cds_show>:
100002a5c: ff c3 01 d1 	sub	sp, sp, #112
100002a60: fd 7b 06 a9 	stp	x29, x30, [sp, #96]
100002a64: fd 83 01 91 	add	x29, sp, #96
100002a68: 08 00 00 d0 	adrp	x8, 0x100004000 <_Cds_show+0x14>
100002a6c: 08 05 40 f9 	ldr	x8, [x8, #8]
100002a70: 08 01 40 f9 	ldr	x8, [x8]
100002a74: a8 83 1f f8 	stur	x8, [x29, #-8]
100002a78: e0 1b 00 f9 	str	x0, [sp, #48]
100002a7c: ff 2b 00 b9 	str	wzr, [sp, #40]
100002a80: 01 00 00 14 	b	0x100002a84 <_Cds_show+0x28>
100002a84: e8 2b 40 b9 	ldr	w8, [sp, #40]
100002a88: e9 1b 40 f9 	ldr	x9, [sp, #48]
100002a8c: 29 09 40 b9 	ldr	w9, [x9, #8]
100002a90: 08 01 09 6b 	subs	w8, w8, w9
100002a94: e8 b7 9f 1a 	cset	w8, ge
100002a98: a8 09 00 37 	tbnz	w8, #0, 0x100002bcc <_Cds_show+0x170>
100002a9c: 01 00 00 14 	b	0x100002aa0 <_Cds_show+0x44>
100002aa0: e1 2b 40 b9 	ldr	w1, [sp, #40]
100002aa4: a0 a3 00 d1 	sub	x0, x29, #40
100002aa8: e0 0f 00 f9 	str	x0, [sp, #24]
100002aac: ef 03 00 94 	bl	0x100003a68 <_Citoa>
100002ab0: e1 0f 40 f9 	ldr	x1, [sp, #24]
100002ab4: e0 2f 00 b9 	str	w0, [sp, #44]
100002ab8: e2 2f 80 b9 	ldrsw	x2, [sp, #44]
100002abc: 20 00 80 52 	mov	w0, #1
100002ac0: e0 23 00 b9 	str	w0, [sp, #32]
100002ac4: e3 04 00 94 	bl	0x100003e50 <_write+0x100003e50>
100002ac8: e0 23 40 b9 	ldr	w0, [sp, #32]
100002acc: 01 00 00 b0 	adrp	x1, 0x100003000 <_Cds_show+0x74>
100002ad0: 21 e4 3b 91 	add	x1, x1, #3833
100002ad4: 62 00 80 d2 	mov	x2, #3
100002ad8: de 04 00 94 	bl	0x100003e50 <_write+0x100003e50>
100002adc: e0 0f 40 f9 	ldr	x0, [sp, #24]
100002ae0: e8 1b 40 f9 	ldr	x8, [sp, #48]
100002ae4: 08 01 40 f9 	ldr	x8, [x8]
100002ae8: e9 2b 80 b9 	ldrsw	x9, [sp, #40]
100002aec: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
100002af0: 01 01 40 b9 	ldr	w1, [x8]
100002af4: dd 03 00 94 	bl	0x100003a68 <_Citoa>
100002af8: e1 0f 40 f9 	ldr	x1, [sp, #24]
100002afc: e8 03 00 aa 	mov	x8, x0
100002b00: e0 23 40 b9 	ldr	w0, [sp, #32]
100002b04: e8 2f 00 b9 	str	w8, [sp, #44]
100002b08: e2 2f 80 b9 	ldrsw	x2, [sp, #44]
100002b0c: d1 04 00 94 	bl	0x100003e50 <_write+0x100003e50>
100002b10: ff 27 00 b9 	str	wzr, [sp, #36]
100002b14: 01 00 00 14 	b	0x100002b18 <_Cds_show+0xbc>
100002b18: e8 27 40 b9 	ldr	w8, [sp, #36]
100002b1c: e9 1b 40 f9 	ldr	x9, [sp, #48]
100002b20: 29 0d 40 b9 	ldr	w9, [x9, #12]
100002b24: 08 01 09 6b 	subs	w8, w8, w9
100002b28: e8 b7 9f 1a 	cset	w8, ge
100002b2c: c8 03 00 37 	tbnz	w8, #0, 0x100002ba4 <_Cds_show+0x148>
100002b30: 01 00 00 14 	b	0x100002b34 <_Cds_show+0xd8>
100002b34: 20 00 80 52 	mov	w0, #1
100002b38: e0 17 00 b9 	str	w0, [sp, #20]
100002b3c: 01 00 00 b0 	adrp	x1, 0x100003000 <_Cds_show+0xe4>
100002b40: 21 f4 3b 91 	add	x1, x1, #3837
100002b44: 22 00 80 d2 	mov	x2, #1
100002b48: c2 04 00 94 	bl	0x100003e50 <_write+0x100003e50>
100002b4c: e1 17 40 b9 	ldr	w1, [sp, #20]
100002b50: e8 1b 40 f9 	ldr	x8, [sp, #48]
100002b54: 08 01 40 f9 	ldr	x8, [x8]
100002b58: e9 2b 80 b9 	ldrsw	x9, [sp, #40]
100002b5c: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
100002b60: 08 05 40 f9 	ldr	x8, [x8, #8]
100002b64: e9 27 80 b9 	ldrsw	x9, [sp, #36]
100002b68: 00 79 69 fc 	ldr	d0, [x8, x9, lsl #3]
100002b6c: a0 a3 00 d1 	sub	x0, x29, #40
100002b70: e0 07 00 f9 	str	x0, [sp, #8]
100002b74: 0f 04 00 94 	bl	0x100003bb0 <_Cdtoa>
100002b78: e1 07 40 f9 	ldr	x1, [sp, #8]
100002b7c: e8 03 00 aa 	mov	x8, x0
100002b80: e0 17 40 b9 	ldr	w0, [sp, #20]
100002b84: e8 2f 00 b9 	str	w8, [sp, #44]
100002b88: e2 2f 80 b9 	ldrsw	x2, [sp, #44]
100002b8c: b1 04 00 94 	bl	0x100003e50 <_write+0x100003e50>
100002b90: 01 00 00 14 	b	0x100002b94 <_Cds_show+0x138>
100002b94: e8 27 40 b9 	ldr	w8, [sp, #36]
100002b98: 08 05 00 11 	add	w8, w8, #1
100002b9c: e8 27 00 b9 	str	w8, [sp, #36]
100002ba0: de ff ff 17 	b	0x100002b18 <_Cds_show+0xbc>
100002ba4: 20 00 80 52 	mov	w0, #1
100002ba8: 01 00 00 b0 	adrp	x1, 0x100003000 <_Cds_show+0x150>
100002bac: 21 fc 3b 91 	add	x1, x1, #3839
100002bb0: 22 00 80 d2 	mov	x2, #1
100002bb4: a7 04 00 94 	bl	0x100003e50 <_write+0x100003e50>
100002bb8: 01 00 00 14 	b	0x100002bbc <_Cds_show+0x160>
100002bbc: e8 2b 40 b9 	ldr	w8, [sp, #40]
100002bc0: 08 05 00 11 	add	w8, w8, #1
100002bc4: e8 2b 00 b9 	str	w8, [sp, #40]
100002bc8: af ff ff 17 	b	0x100002a84 <_Cds_show+0x28>
100002bcc: a9 83 5f f8 	ldur	x9, [x29, #-8]
100002bd0: 08 00 00 d0 	adrp	x8, 0x100004000 <_Cds_show+0x17c>
100002bd4: 08 05 40 f9 	ldr	x8, [x8, #8]
100002bd8: 08 01 40 f9 	ldr	x8, [x8]
100002bdc: 08 01 09 eb 	subs	x8, x8, x9
100002be0: e8 17 9f 1a 	cset	w8, eq
100002be4: 68 00 00 37 	tbnz	w8, #0, 0x100002bf0 <_Cds_show+0x194>
100002be8: 01 00 00 14 	b	0x100002bec <_Cds_show+0x190>
100002bec: 72 04 00 94 	bl	0x100003db4 <_write+0x100003db4>
100002bf0: fd 7b 46 a9 	ldp	x29, x30, [sp, #96]
100002bf4: ff c3 01 91 	add	sp, sp, #112
100002bf8: c0 03 5f d6 	ret

0000000100002bfc <_Cds_normalize>:
100002bfc: ff 03 01 d1 	sub	sp, sp, #64
100002c00: e0 1f 00 f9 	str	x0, [sp, #56]
100002c04: ff 37 00 b9 	str	wzr, [sp, #52]
100002c08: 01 00 00 14 	b	0x100002c0c <_Cds_normalize+0x10>
100002c0c: e8 37 40 b9 	ldr	w8, [sp, #52]
100002c10: e9 1f 40 f9 	ldr	x9, [sp, #56]
100002c14: 29 0d 40 b9 	ldr	w9, [x9, #12]
100002c18: 08 01 09 6b 	subs	w8, w8, w9
100002c1c: e8 b7 9f 1a 	cset	w8, ge
100002c20: 68 0e 00 37 	tbnz	w8, #0, 0x100002dec <_Cds_normalize+0x1f0>
100002c24: 01 00 00 14 	b	0x100002c28 <_Cds_normalize+0x2c>
100002c28: 00 e4 00 2f 	movi	d0, #0000000000000000
100002c2c: e0 17 00 fd 	str	d0, [sp, #40]
100002c30: ff 27 00 b9 	str	wzr, [sp, #36]
100002c34: 01 00 00 14 	b	0x100002c38 <_Cds_normalize+0x3c>
100002c38: e8 27 40 b9 	ldr	w8, [sp, #36]
100002c3c: e9 1f 40 f9 	ldr	x9, [sp, #56]
100002c40: 29 09 40 b9 	ldr	w9, [x9, #8]
100002c44: 08 01 09 6b 	subs	w8, w8, w9
100002c48: e8 b7 9f 1a 	cset	w8, ge
100002c4c: 28 02 00 37 	tbnz	w8, #0, 0x100002c90 <_Cds_normalize+0x94>
100002c50: 01 00 00 14 	b	0x100002c54 <_Cds_normalize+0x58>
100002c54: e8 1f 40 f9 	ldr	x8, [sp, #56]
100002c58: 08 01 40 f9 	ldr	x8, [x8]
100002c5c: e9 27 80 b9 	ldrsw	x9, [sp, #36]
100002c60: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
100002c64: 08 05 40 f9 	ldr	x8, [x8, #8]
100002c68: e9 37 80 b9 	ldrsw	x9, [sp, #52]
100002c6c: 01 79 69 fc 	ldr	d1, [x8, x9, lsl #3]
100002c70: e0 17 40 fd 	ldr	d0, [sp, #40]
100002c74: 00 28 61 1e 	fadd	d0, d0, d1
100002c78: e0 17 00 fd 	str	d0, [sp, #40]
100002c7c: 01 00 00 14 	b	0x100002c80 <_Cds_normalize+0x84>
100002c80: e8 27 40 b9 	ldr	w8, [sp, #36]
100002c84: 08 05 00 11 	add	w8, w8, #1
100002c88: e8 27 00 b9 	str	w8, [sp, #36]
100002c8c: eb ff ff 17 	b	0x100002c38 <_Cds_normalize+0x3c>
100002c90: e8 1f 40 f9 	ldr	x8, [sp, #56]
100002c94: 01 09 40 bd 	ldr	s1, [x8, #8]
100002c98: 20 40 20 1e 	fmov	s0, s1
100002c9c: 00 a4 20 0f 	sshll.2d	v0, v0, #0
100002ca0: 01 d8 61 5e 	scvtf	d1, d0
100002ca4: e0 17 40 fd 	ldr	d0, [sp, #40]
100002ca8: 00 18 61 1e 	fdiv	d0, d0, d1
100002cac: e0 17 00 fd 	str	d0, [sp, #40]
100002cb0: 00 e4 00 2f 	movi	d0, #0000000000000000
100002cb4: e0 0f 00 fd 	str	d0, [sp, #24]
100002cb8: ff 17 00 b9 	str	wzr, [sp, #20]
100002cbc: 01 00 00 14 	b	0x100002cc0 <_Cds_normalize+0xc4>
100002cc0: e8 17 40 b9 	ldr	w8, [sp, #20]
100002cc4: e9 1f 40 f9 	ldr	x9, [sp, #56]
100002cc8: 29 09 40 b9 	ldr	w9, [x9, #8]
100002ccc: 08 01 09 6b 	subs	w8, w8, w9
100002cd0: e8 b7 9f 1a 	cset	w8, ge
100002cd4: c8 02 00 37 	tbnz	w8, #0, 0x100002d2c <_Cds_normalize+0x130>
100002cd8: 01 00 00 14 	b	0x100002cdc <_Cds_normalize+0xe0>
100002cdc: e8 1f 40 f9 	ldr	x8, [sp, #56]
100002ce0: 08 01 40 f9 	ldr	x8, [x8]
100002ce4: e9 17 80 b9 	ldrsw	x9, [sp, #20]
100002ce8: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
100002cec: 08 05 40 f9 	ldr	x8, [x8, #8]
100002cf0: e9 37 80 b9 	ldrsw	x9, [sp, #52]
100002cf4: 00 79 69 fc 	ldr	d0, [x8, x9, lsl #3]
100002cf8: e1 17 40 fd 	ldr	d1, [sp, #40]
100002cfc: 00 38 61 1e 	fsub	d0, d0, d1
100002d00: e0 07 00 fd 	str	d0, [sp, #8]
100002d04: e0 07 40 fd 	ldr	d0, [sp, #8]
100002d08: e1 07 40 fd 	ldr	d1, [sp, #8]
100002d0c: e2 0f 40 fd 	ldr	d2, [sp, #24]
100002d10: 00 08 41 1f 	fmadd	d0, d0, d1, d2
100002d14: e0 0f 00 fd 	str	d0, [sp, #24]
100002d18: 01 00 00 14 	b	0x100002d1c <_Cds_normalize+0x120>
100002d1c: e8 17 40 b9 	ldr	w8, [sp, #20]
100002d20: 08 05 00 11 	add	w8, w8, #1
100002d24: e8 17 00 b9 	str	w8, [sp, #20]
100002d28: e6 ff ff 17 	b	0x100002cc0 <_Cds_normalize+0xc4>
100002d2c: e8 1f 40 f9 	ldr	x8, [sp, #56]
100002d30: 01 09 40 bd 	ldr	s1, [x8, #8]
100002d34: 20 40 20 1e 	fmov	s0, s1
100002d38: 00 a4 20 0f 	sshll.2d	v0, v0, #0
100002d3c: 01 d8 61 5e 	scvtf	d1, d0
100002d40: e0 0f 40 fd 	ldr	d0, [sp, #24]
100002d44: 00 18 61 1e 	fdiv	d0, d0, d1
100002d48: e0 0f 00 fd 	str	d0, [sp, #24]
100002d4c: e0 0f 40 fd 	ldr	d0, [sp, #24]
100002d50: 00 c0 61 1e 	fsqrt	d0, d0
100002d54: e0 0f 00 fd 	str	d0, [sp, #24]
100002d58: ff 07 00 b9 	str	wzr, [sp, #4]
100002d5c: 01 00 00 14 	b	0x100002d60 <_Cds_normalize+0x164>
100002d60: e8 07 40 b9 	ldr	w8, [sp, #4]
100002d64: e9 1f 40 f9 	ldr	x9, [sp, #56]
100002d68: 29 09 40 b9 	ldr	w9, [x9, #8]
100002d6c: 08 01 09 6b 	subs	w8, w8, w9
100002d70: e8 b7 9f 1a 	cset	w8, ge
100002d74: 28 03 00 37 	tbnz	w8, #0, 0x100002dd8 <_Cds_normalize+0x1dc>
100002d78: 01 00 00 14 	b	0x100002d7c <_Cds_normalize+0x180>
100002d7c: e8 1f 40 f9 	ldr	x8, [sp, #56]
100002d80: 08 01 40 f9 	ldr	x8, [x8]
100002d84: e9 07 80 b9 	ldrsw	x9, [sp, #4]
100002d88: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
100002d8c: 08 05 40 f9 	ldr	x8, [x8, #8]
100002d90: e9 37 80 b9 	ldrsw	x9, [sp, #52]
100002d94: 00 79 69 fc 	ldr	d0, [x8, x9, lsl #3]
100002d98: e1 17 40 fd 	ldr	d1, [sp, #40]
100002d9c: 00 38 61 1e 	fsub	d0, d0, d1
100002da0: e1 0f 40 fd 	ldr	d1, [sp, #24]
100002da4: 00 18 61 1e 	fdiv	d0, d0, d1
100002da8: e8 1f 40 f9 	ldr	x8, [sp, #56]
100002dac: 08 01 40 f9 	ldr	x8, [x8]
100002db0: e9 07 80 b9 	ldrsw	x9, [sp, #4]
100002db4: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
100002db8: 08 05 40 f9 	ldr	x8, [x8, #8]
100002dbc: e9 37 80 b9 	ldrsw	x9, [sp, #52]
100002dc0: 00 79 29 fc 	str	d0, [x8, x9, lsl #3]
100002dc4: 01 00 00 14 	b	0x100002dc8 <_Cds_normalize+0x1cc>
100002dc8: e8 07 40 b9 	ldr	w8, [sp, #4]
100002dcc: 08 05 00 11 	add	w8, w8, #1
100002dd0: e8 07 00 b9 	str	w8, [sp, #4]
100002dd4: e3 ff ff 17 	b	0x100002d60 <_Cds_normalize+0x164>
100002dd8: 01 00 00 14 	b	0x100002ddc <_Cds_normalize+0x1e0>
100002ddc: e8 37 40 b9 	ldr	w8, [sp, #52]
100002de0: 08 05 00 11 	add	w8, w8, #1
100002de4: e8 37 00 b9 	str	w8, [sp, #52]
100002de8: 89 ff ff 17 	b	0x100002c0c <_Cds_normalize+0x10>
100002dec: ff 03 01 91 	add	sp, sp, #64
100002df0: c0 03 5f d6 	ret

0000000100002df4 <_C_sigmoid>:
100002df4: ff 83 00 d1 	sub	sp, sp, #32
100002df8: fd 7b 01 a9 	stp	x29, x30, [sp, #16]
100002dfc: fd 43 00 91 	add	x29, sp, #16
100002e00: e0 07 00 fd 	str	d0, [sp, #8]
100002e04: e0 07 40 fd 	ldr	d0, [sp, #8]
100002e08: 00 40 61 1e 	fneg	d0, d0
100002e0c: f6 03 00 94 	bl	0x100003de4 <_write+0x100003de4>
100002e10: 01 40 60 1e 	fmov	d1, d0
100002e14: 00 10 6e 1e 	fmov	d0, #1.00000000
100002e18: 01 28 61 1e 	fadd	d1, d0, d1
100002e1c: 00 18 61 1e 	fdiv	d0, d0, d1
100002e20: fd 7b 41 a9 	ldp	x29, x30, [sp, #16]
100002e24: ff 83 00 91 	add	sp, sp, #32
100002e28: c0 03 5f d6 	ret

0000000100002e2c <_C_compute_mem_reqs>:
100002e2c: ff 43 00 d1 	sub	sp, sp, #16
100002e30: e0 0f 00 b9 	str	w0, [sp, #12]
100002e34: e1 0b 00 b9 	str	w1, [sp, #8]
100002e38: e9 0b 80 b9 	ldrsw	x9, [sp, #8]
100002e3c: 08 01 80 d2 	mov	x8, #8
100002e40: 08 7d 09 9b 	mul	x8, x8, x9
100002e44: e9 0f 40 b9 	ldr	w9, [sp, #12]
100002e48: 2a 0d 00 11 	add	w10, w9, #3
100002e4c: e9 03 0a aa 	mov	x9, x10
100002e50: 29 7d 40 93 	sxtw	x9, w9
100002e54: 00 7d 09 9b 	mul	x0, x8, x9
100002e58: ff 43 00 91 	add	sp, sp, #16
100002e5c: c0 03 5f d6 	ret

0000000100002e60 <_C_zero_outputs>:
100002e60: ff 43 00 d1 	sub	sp, sp, #16
100002e64: e0 07 00 f9 	str	x0, [sp, #8]
100002e68: e8 07 40 f9 	ldr	x8, [sp, #8]
100002e6c: 00 e4 00 2f 	movi	d0, #0000000000000000
100002e70: 00 1d 00 fd 	str	d0, [x8, #56]
100002e74: ff 07 00 b9 	str	wzr, [sp, #4]
100002e78: 01 00 00 14 	b	0x100002e7c <_C_zero_outputs+0x1c>
100002e7c: e8 07 40 b9 	ldr	w8, [sp, #4]
100002e80: e9 07 40 f9 	ldr	x9, [sp, #8]
100002e84: 29 05 40 b9 	ldr	w9, [x9, #4]
100002e88: 08 01 09 6b 	subs	w8, w8, w9
100002e8c: e8 b7 9f 1a 	cset	w8, ge
100002e90: 88 01 00 37 	tbnz	w8, #0, 0x100002ec0 <_C_zero_outputs+0x60>
100002e94: 01 00 00 14 	b	0x100002e98 <_C_zero_outputs+0x38>
100002e98: e8 07 40 f9 	ldr	x8, [sp, #8]
100002e9c: 08 11 40 f9 	ldr	x8, [x8, #32]
100002ea0: e9 07 80 b9 	ldrsw	x9, [sp, #4]
100002ea4: 00 e4 00 2f 	movi	d0, #0000000000000000
100002ea8: 00 79 29 fc 	str	d0, [x8, x9, lsl #3]
100002eac: 01 00 00 14 	b	0x100002eb0 <_C_zero_outputs+0x50>
100002eb0: e8 07 40 b9 	ldr	w8, [sp, #4]
100002eb4: 08 05 00 11 	add	w8, w8, #1
100002eb8: e8 07 00 b9 	str	w8, [sp, #4]
100002ebc: f0 ff ff 17 	b	0x100002e7c <_C_zero_outputs+0x1c>
100002ec0: ff 43 00 91 	add	sp, sp, #16
100002ec4: c0 03 5f d6 	ret

0000000100002ec8 <_C_random_01>:
100002ec8: fd 7b bf a9 	stp	x29, x30, [sp, #-16]!
100002ecc: fd 03 00 91 	mov	x29, sp
100002ed0: da 03 00 94 	bl	0x100003e38 <_write+0x100003e38>
100002ed4: 00 00 62 1e 	scvtf	d0, w0
100002ed8: 08 00 00 b0 	adrp	x8, 0x100003000 <_C_random_01+0x14>
100002edc: 01 b1 47 fd 	ldr	d1, [x8, #3936]
100002ee0: 00 18 61 1e 	fdiv	d0, d0, d1
100002ee4: fd 7b c1 a8 	ldp	x29, x30, [sp], #16
100002ee8: c0 03 5f d6 	ret

0000000100002eec <_C_random_weights>:
100002eec: ff 83 00 d1 	sub	sp, sp, #32
100002ef0: fd 7b 01 a9 	stp	x29, x30, [sp, #16]
100002ef4: fd 43 00 91 	add	x29, sp, #16
100002ef8: e0 07 00 f9 	str	x0, [sp, #8]
100002efc: ff 07 00 b9 	str	wzr, [sp, #4]
100002f00: 01 00 00 14 	b	0x100002f04 <_C_random_weights+0x18>
100002f04: e8 07 40 b9 	ldr	w8, [sp, #4]
100002f08: e9 07 40 f9 	ldr	x9, [sp, #8]
100002f0c: 29 05 40 b9 	ldr	w9, [x9, #4]
100002f10: 08 01 09 6b 	subs	w8, w8, w9
100002f14: e8 b7 9f 1a 	cset	w8, ge
100002f18: 28 05 00 37 	tbnz	w8, #0, 0x100002fbc <_C_random_weights+0xd0>
100002f1c: 01 00 00 14 	b	0x100002f20 <_C_random_weights+0x34>
100002f20: ff 03 00 b9 	str	wzr, [sp]
100002f24: 01 00 00 14 	b	0x100002f28 <_C_random_weights+0x3c>
100002f28: e8 03 40 b9 	ldr	w8, [sp]
100002f2c: e9 07 40 f9 	ldr	x9, [sp, #8]
100002f30: 29 01 40 b9 	ldr	w9, [x9]
100002f34: 08 01 09 6b 	subs	w8, w8, w9
100002f38: e8 b7 9f 1a 	cset	w8, ge
100002f3c: 28 02 00 37 	tbnz	w8, #0, 0x100002f80 <_C_random_weights+0x94>
100002f40: 01 00 00 14 	b	0x100002f44 <_C_random_weights+0x58>
100002f44: e1 ff ff 97 	bl	0x100002ec8 <_C_random_01>
100002f48: e8 07 40 f9 	ldr	x8, [sp, #8]
100002f4c: 08 09 40 f9 	ldr	x8, [x8, #16]
100002f50: e9 03 40 b9 	ldr	w9, [sp]
100002f54: ea 07 40 f9 	ldr	x10, [sp, #8]
100002f58: 4a 05 40 b9 	ldr	w10, [x10, #4]
100002f5c: 29 7d 0a 1b 	mul	w9, w9, w10
100002f60: ea 07 40 b9 	ldr	w10, [sp, #4]
100002f64: 29 01 0a 0b 	add	w9, w9, w10
100002f68: 00 d9 29 fc 	str	d0, [x8, w9, sxtw #3]
100002f6c: 01 00 00 14 	b	0x100002f70 <_C_random_weights+0x84>
100002f70: e8 03 40 b9 	ldr	w8, [sp]
100002f74: 08 05 00 11 	add	w8, w8, #1
100002f78: e8 03 00 b9 	str	w8, [sp]
100002f7c: eb ff ff 17 	b	0x100002f28 <_C_random_weights+0x3c>
100002f80: d2 ff ff 97 	bl	0x100002ec8 <_C_random_01>
100002f84: e8 07 40 f9 	ldr	x8, [sp, #8]
100002f88: 08 0d 40 f9 	ldr	x8, [x8, #24]
100002f8c: e9 07 80 b9 	ldrsw	x9, [sp, #4]
100002f90: 00 79 29 fc 	str	d0, [x8, x9, lsl #3]
100002f94: cd ff ff 97 	bl	0x100002ec8 <_C_random_01>
100002f98: e8 07 40 f9 	ldr	x8, [sp, #8]
100002f9c: 08 15 40 f9 	ldr	x8, [x8, #40]
100002fa0: e9 07 80 b9 	ldrsw	x9, [sp, #4]
100002fa4: 00 79 29 fc 	str	d0, [x8, x9, lsl #3]
100002fa8: 01 00 00 14 	b	0x100002fac <_C_random_weights+0xc0>
100002fac: e8 07 40 b9 	ldr	w8, [sp, #4]
100002fb0: 08 05 00 11 	add	w8, w8, #1
100002fb4: e8 07 00 b9 	str	w8, [sp, #4]
100002fb8: d3 ff ff 17 	b	0x100002f04 <_C_random_weights+0x18>
100002fbc: c3 ff ff 97 	bl	0x100002ec8 <_C_random_01>
100002fc0: e8 07 40 f9 	ldr	x8, [sp, #8]
100002fc4: 00 19 00 fd 	str	d0, [x8, #48]
100002fc8: fd 7b 41 a9 	ldp	x29, x30, [sp, #16]
100002fcc: ff 83 00 91 	add	sp, sp, #32
100002fd0: c0 03 5f d6 	ret

0000000100002fd4 <_Cnn_init>:
100002fd4: ff c3 00 d1 	sub	sp, sp, #48
100002fd8: fd 7b 02 a9 	stp	x29, x30, [sp, #32]
100002fdc: fd 83 00 91 	add	x29, sp, #32
100002fe0: a0 83 1f f8 	stur	x0, [x29, #-8]
100002fe4: a1 43 1f b8 	stur	w1, [x29, #-12]
100002fe8: e2 13 00 b9 	str	w2, [sp, #16]
100002fec: e0 07 00 fd 	str	d0, [sp, #8]
100002ff0: a8 43 5f b8 	ldur	w8, [x29, #-12]
100002ff4: a9 83 5f f8 	ldur	x9, [x29, #-8]
100002ff8: 28 01 00 b9 	str	w8, [x9]
100002ffc: e8 13 40 b9 	ldr	w8, [sp, #16]
100003000: a9 83 5f f8 	ldur	x9, [x29, #-8]
100003004: 28 05 00 b9 	str	w8, [x9, #4]
100003008: e0 07 40 fd 	ldr	d0, [sp, #8]
10000300c: a8 83 5f f8 	ldur	x8, [x29, #-8]
100003010: 00 05 00 fd 	str	d0, [x8, #8]
100003014: a0 43 5f b8 	ldur	w0, [x29, #-12]
100003018: e1 13 40 b9 	ldr	w1, [sp, #16]
10000301c: 84 ff ff 97 	bl	0x100002e2c <_C_compute_mem_reqs>
100003020: e8 03 00 aa 	mov	x8, x0
100003024: e8 07 00 b9 	str	w8, [sp, #4]
100003028: e1 07 80 b9 	ldrsw	x1, [sp, #4]
10000302c: 00 00 80 d2 	mov	x0, #0
100003030: 62 00 80 52 	mov	w2, #3
100003034: 23 00 82 52 	mov	w3, #4097
100003038: 04 00 80 12 	mov	w4, #-1
10000303c: 05 00 80 d2 	mov	x5, #0
100003040: 6f 03 00 94 	bl	0x100003dfc <_write+0x100003dfc>
100003044: a8 83 5f f8 	ldur	x8, [x29, #-8]
100003048: 00 09 00 f9 	str	x0, [x8, #16]
10000304c: a8 83 5f f8 	ldur	x8, [x29, #-8]
100003050: 08 09 40 f9 	ldr	x8, [x8, #16]
100003054: 08 05 00 b1 	adds	x8, x8, #1
100003058: e8 07 9f 1a 	cset	w8, ne
10000305c: e8 00 00 37 	tbnz	w8, #0, 0x100003078 <_Cnn_init+0xa4>
100003060: 01 00 00 14 	b	0x100003064 <_Cnn_init+0x90>
100003064: 00 00 00 90 	adrp	x0, 0x100003000 <_Cnn_init+0x90>
100003068: 00 04 3c 91 	add	x0, x0, #3841
10000306c: 70 03 00 94 	bl	0x100003e2c <_write+0x100003e2c>
100003070: 20 00 80 52 	mov	w0, #1
100003074: 59 03 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
100003078: a8 83 5f f8 	ldur	x8, [x29, #-8]
10000307c: 08 09 40 f9 	ldr	x8, [x8, #16]
100003080: a9 43 5f b8 	ldur	w9, [x29, #-12]
100003084: ea 13 40 b9 	ldr	w10, [sp, #16]
100003088: 29 7d 0a 1b 	mul	w9, w9, w10
10000308c: 08 cd 29 8b 	add	x8, x8, w9, sxtw #3
100003090: a9 83 5f f8 	ldur	x9, [x29, #-8]
100003094: 28 0d 00 f9 	str	x8, [x9, #24]
100003098: a8 83 5f f8 	ldur	x8, [x29, #-8]
10000309c: 08 0d 40 f9 	ldr	x8, [x8, #24]
1000030a0: e9 13 80 b9 	ldrsw	x9, [sp, #16]
1000030a4: 08 0d 09 8b 	add	x8, x8, x9, lsl #3
1000030a8: a9 83 5f f8 	ldur	x9, [x29, #-8]
1000030ac: 28 11 00 f9 	str	x8, [x9, #32]
1000030b0: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000030b4: 08 11 40 f9 	ldr	x8, [x8, #32]
1000030b8: e9 13 80 b9 	ldrsw	x9, [sp, #16]
1000030bc: 08 0d 09 8b 	add	x8, x8, x9, lsl #3
1000030c0: a9 83 5f f8 	ldur	x9, [x29, #-8]
1000030c4: 28 15 00 f9 	str	x8, [x9, #40]
1000030c8: a0 83 5f f8 	ldur	x0, [x29, #-8]
1000030cc: 65 ff ff 97 	bl	0x100002e60 <_C_zero_outputs>
1000030d0: a0 83 5f f8 	ldur	x0, [x29, #-8]
1000030d4: 86 ff ff 97 	bl	0x100002eec <_C_random_weights>
1000030d8: fd 7b 42 a9 	ldp	x29, x30, [sp, #32]
1000030dc: ff c3 00 91 	add	sp, sp, #48
1000030e0: c0 03 5f d6 	ret

00000001000030e4 <_Cnn_destroy>:
1000030e4: ff 83 00 d1 	sub	sp, sp, #32
1000030e8: fd 7b 01 a9 	stp	x29, x30, [sp, #16]
1000030ec: fd 43 00 91 	add	x29, sp, #16
1000030f0: e0 07 00 f9 	str	x0, [sp, #8]
1000030f4: e8 07 40 f9 	ldr	x8, [sp, #8]
1000030f8: 00 01 40 b9 	ldr	w0, [x8]
1000030fc: e8 07 40 f9 	ldr	x8, [sp, #8]
100003100: 01 05 40 b9 	ldr	w1, [x8, #4]
100003104: 4a ff ff 97 	bl	0x100002e2c <_C_compute_mem_reqs>
100003108: e8 03 00 aa 	mov	x8, x0
10000310c: e8 07 00 b9 	str	w8, [sp, #4]
100003110: e8 07 40 f9 	ldr	x8, [sp, #8]
100003114: 00 09 40 f9 	ldr	x0, [x8, #16]
100003118: e1 07 80 b9 	ldrsw	x1, [sp, #4]
10000311c: 3b 03 00 94 	bl	0x100003e08 <_write+0x100003e08>
100003120: e0 03 00 b9 	str	w0, [sp]
100003124: e8 03 40 b9 	ldr	w8, [sp]
100003128: 08 01 00 71 	subs	w8, w8, #0
10000312c: e8 17 9f 1a 	cset	w8, eq
100003130: e8 00 00 37 	tbnz	w8, #0, 0x10000314c <_Cnn_destroy+0x68>
100003134: 01 00 00 14 	b	0x100003138 <_Cnn_destroy+0x54>
100003138: 00 00 00 90 	adrp	x0, 0x100003000 <_Cnn_destroy+0x54>
10000313c: 00 54 3c 91 	add	x0, x0, #3861
100003140: 38 03 00 94 	bl	0x100003e20 <_write+0x100003e20>
100003144: 40 00 80 52 	mov	w0, #2
100003148: 24 03 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
10000314c: fd 7b 41 a9 	ldp	x29, x30, [sp, #16]
100003150: ff 83 00 91 	add	sp, sp, #32
100003154: c0 03 5f d6 	ret

0000000100003158 <_Cnn_forward>:
100003158: ff c3 00 d1 	sub	sp, sp, #48
10000315c: fd 7b 02 a9 	stp	x29, x30, [sp, #32]
100003160: fd 83 00 91 	add	x29, sp, #32
100003164: a0 83 1f f8 	stur	x0, [x29, #-8]
100003168: e1 0b 00 f9 	str	x1, [sp, #16]
10000316c: a0 83 5f f8 	ldur	x0, [x29, #-8]
100003170: 3c ff ff 97 	bl	0x100002e60 <_C_zero_outputs>
100003174: ff 0f 00 b9 	str	wzr, [sp, #12]
100003178: 01 00 00 14 	b	0x10000317c <_Cnn_forward+0x24>
10000317c: e8 0f 40 b9 	ldr	w8, [sp, #12]
100003180: a9 83 5f f8 	ldur	x9, [x29, #-8]
100003184: 29 01 40 b9 	ldr	w9, [x9]
100003188: 08 01 09 6b 	subs	w8, w8, w9
10000318c: e8 b7 9f 1a 	cset	w8, ge
100003190: 08 05 00 37 	tbnz	w8, #0, 0x100003230 <_Cnn_forward+0xd8>
100003194: 01 00 00 14 	b	0x100003198 <_Cnn_forward+0x40>
100003198: ff 0b 00 b9 	str	wzr, [sp, #8]
10000319c: 01 00 00 14 	b	0x1000031a0 <_Cnn_forward+0x48>
1000031a0: e8 0b 40 b9 	ldr	w8, [sp, #8]
1000031a4: a9 83 5f f8 	ldur	x9, [x29, #-8]
1000031a8: 29 05 40 b9 	ldr	w9, [x9, #4]
1000031ac: 08 01 09 6b 	subs	w8, w8, w9
1000031b0: e8 b7 9f 1a 	cset	w8, ge
1000031b4: 48 03 00 37 	tbnz	w8, #0, 0x10000321c <_Cnn_forward+0xc4>
1000031b8: 01 00 00 14 	b	0x1000031bc <_Cnn_forward+0x64>
1000031bc: e8 0b 40 f9 	ldr	x8, [sp, #16]
1000031c0: e9 0f 80 b9 	ldrsw	x9, [sp, #12]
1000031c4: 00 79 69 fc 	ldr	d0, [x8, x9, lsl #3]
1000031c8: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000031cc: 08 09 40 f9 	ldr	x8, [x8, #16]
1000031d0: e9 0f 40 b9 	ldr	w9, [sp, #12]
1000031d4: aa 83 5f f8 	ldur	x10, [x29, #-8]
1000031d8: 4a 05 40 b9 	ldr	w10, [x10, #4]
1000031dc: 29 7d 0a 1b 	mul	w9, w9, w10
1000031e0: ea 0b 40 b9 	ldr	w10, [sp, #8]
1000031e4: 29 01 0a 0b 	add	w9, w9, w10
1000031e8: 01 d9 69 fc 	ldr	d1, [x8, w9, sxtw #3]
1000031ec: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000031f0: 08 11 40 f9 	ldr	x8, [x8, #32]
1000031f4: e9 0b 80 b9 	ldrsw	x9, [sp, #8]
1000031f8: 08 0d 09 8b 	add	x8, x8, x9, lsl #3
1000031fc: 02 01 40 fd 	ldr	d2, [x8]
100003200: 00 08 41 1f 	fmadd	d0, d0, d1, d2
100003204: 00 01 00 fd 	str	d0, [x8]
100003208: 01 00 00 14 	b	0x10000320c <_Cnn_forward+0xb4>
10000320c: e8 0b 40 b9 	ldr	w8, [sp, #8]
100003210: 08 05 00 11 	add	w8, w8, #1
100003214: e8 0b 00 b9 	str	w8, [sp, #8]
100003218: e2 ff ff 17 	b	0x1000031a0 <_Cnn_forward+0x48>
10000321c: 01 00 00 14 	b	0x100003220 <_Cnn_forward+0xc8>
100003220: e8 0f 40 b9 	ldr	w8, [sp, #12]
100003224: 08 05 00 11 	add	w8, w8, #1
100003228: e8 0f 00 b9 	str	w8, [sp, #12]
10000322c: d4 ff ff 17 	b	0x10000317c <_Cnn_forward+0x24>
100003230: ff 07 00 b9 	str	wzr, [sp, #4]
100003234: 01 00 00 14 	b	0x100003238 <_Cnn_forward+0xe0>
100003238: e8 07 40 b9 	ldr	w8, [sp, #4]
10000323c: a9 83 5f f8 	ldur	x9, [x29, #-8]
100003240: 29 05 40 b9 	ldr	w9, [x9, #4]
100003244: 08 01 09 6b 	subs	w8, w8, w9
100003248: e8 b7 9f 1a 	cset	w8, ge
10000324c: a8 02 00 37 	tbnz	w8, #0, 0x1000032a0 <_Cnn_forward+0x148>
100003250: 01 00 00 14 	b	0x100003254 <_Cnn_forward+0xfc>
100003254: a8 83 5f f8 	ldur	x8, [x29, #-8]
100003258: 08 11 40 f9 	ldr	x8, [x8, #32]
10000325c: e9 07 80 b9 	ldrsw	x9, [sp, #4]
100003260: 00 79 69 fc 	ldr	d0, [x8, x9, lsl #3]
100003264: a8 83 5f f8 	ldur	x8, [x29, #-8]
100003268: 08 0d 40 f9 	ldr	x8, [x8, #24]
10000326c: e9 07 80 b9 	ldrsw	x9, [sp, #4]
100003270: 01 79 69 fc 	ldr	d1, [x8, x9, lsl #3]
100003274: 00 28 61 1e 	fadd	d0, d0, d1
100003278: df fe ff 97 	bl	0x100002df4 <_C_sigmoid>
10000327c: a8 83 5f f8 	ldur	x8, [x29, #-8]
100003280: 08 11 40 f9 	ldr	x8, [x8, #32]
100003284: e9 07 80 b9 	ldrsw	x9, [sp, #4]
100003288: 00 79 29 fc 	str	d0, [x8, x9, lsl #3]
10000328c: 01 00 00 14 	b	0x100003290 <_Cnn_forward+0x138>
100003290: e8 07 40 b9 	ldr	w8, [sp, #4]
100003294: 08 05 00 11 	add	w8, w8, #1
100003298: e8 07 00 b9 	str	w8, [sp, #4]
10000329c: e7 ff ff 17 	b	0x100003238 <_Cnn_forward+0xe0>
1000032a0: ff 03 00 b9 	str	wzr, [sp]
1000032a4: 01 00 00 14 	b	0x1000032a8 <_Cnn_forward+0x150>
1000032a8: e8 03 40 b9 	ldr	w8, [sp]
1000032ac: a9 83 5f f8 	ldur	x9, [x29, #-8]
1000032b0: 29 05 40 b9 	ldr	w9, [x9, #4]
1000032b4: 08 01 09 6b 	subs	w8, w8, w9
1000032b8: e8 b7 9f 1a 	cset	w8, ge
1000032bc: 68 02 00 37 	tbnz	w8, #0, 0x100003308 <_Cnn_forward+0x1b0>
1000032c0: 01 00 00 14 	b	0x1000032c4 <_Cnn_forward+0x16c>
1000032c4: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000032c8: 08 11 40 f9 	ldr	x8, [x8, #32]
1000032cc: e9 03 80 b9 	ldrsw	x9, [sp]
1000032d0: 00 79 69 fc 	ldr	d0, [x8, x9, lsl #3]
1000032d4: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000032d8: 08 15 40 f9 	ldr	x8, [x8, #40]
1000032dc: e9 03 80 b9 	ldrsw	x9, [sp]
1000032e0: 01 79 69 fc 	ldr	d1, [x8, x9, lsl #3]
1000032e4: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000032e8: 02 1d 40 fd 	ldr	d2, [x8, #56]
1000032ec: 00 08 41 1f 	fmadd	d0, d0, d1, d2
1000032f0: 00 1d 00 fd 	str	d0, [x8, #56]
1000032f4: 01 00 00 14 	b	0x1000032f8 <_Cnn_forward+0x1a0>
1000032f8: e8 03 40 b9 	ldr	w8, [sp]
1000032fc: 08 05 00 11 	add	w8, w8, #1
100003300: e8 03 00 b9 	str	w8, [sp]
100003304: e9 ff ff 17 	b	0x1000032a8 <_Cnn_forward+0x150>
100003308: a8 83 5f f8 	ldur	x8, [x29, #-8]
10000330c: 01 19 40 fd 	ldr	d1, [x8, #48]
100003310: a8 83 5f f8 	ldur	x8, [x29, #-8]
100003314: 00 1d 40 fd 	ldr	d0, [x8, #56]
100003318: 00 28 61 1e 	fadd	d0, d0, d1
10000331c: 00 1d 00 fd 	str	d0, [x8, #56]
100003320: a8 83 5f f8 	ldur	x8, [x29, #-8]
100003324: 00 1d 40 fd 	ldr	d0, [x8, #56]
100003328: fd 7b 42 a9 	ldp	x29, x30, [sp, #32]
10000332c: ff c3 00 91 	add	sp, sp, #48
100003330: c0 03 5f d6 	ret

0000000100003334 <_Cnn_backward>:
100003334: ff 43 01 d1 	sub	sp, sp, #80
100003338: e0 27 00 f9 	str	x0, [sp, #72]
10000333c: e1 23 00 f9 	str	x1, [sp, #64]
100003340: e2 3f 00 b9 	str	w2, [sp, #60]
100003344: e8 27 40 f9 	ldr	x8, [sp, #72]
100003348: 00 1d 40 fd 	ldr	d0, [x8, #56]
10000334c: e2 3f 40 bd 	ldr	s2, [sp, #60]
100003350: 41 40 20 1e 	fmov	s1, s2
100003354: 21 a4 20 0f 	sshll.2d	v1, v1, #0
100003358: 21 d8 61 5e 	scvtf	d1, d1
10000335c: 01 38 61 1e 	fsub	d1, d0, d1
100003360: 00 10 60 1e 	fmov	d0, #2.00000000
100003364: 00 08 61 1e 	fmul	d0, d0, d1
100003368: e0 1b 00 fd 	str	d0, [sp, #48]
10000336c: e8 27 40 f9 	ldr	x8, [sp, #72]
100003370: 00 05 40 fd 	ldr	d0, [x8, #8]
100003374: e1 1b 40 fd 	ldr	d1, [sp, #48]
100003378: e8 27 40 f9 	ldr	x8, [sp, #72]
10000337c: 02 19 40 fd 	ldr	d2, [x8, #48]
100003380: 00 88 41 1f 	fmsub	d0, d0, d1, d2
100003384: 00 19 00 fd 	str	d0, [x8, #48]
100003388: ff 2f 00 b9 	str	wzr, [sp, #44]
10000338c: 01 00 00 14 	b	0x100003390 <_Cnn_backward+0x5c>
100003390: e8 2f 40 b9 	ldr	w8, [sp, #44]
100003394: e9 27 40 f9 	ldr	x9, [sp, #72]
100003398: 29 05 40 b9 	ldr	w9, [x9, #4]
10000339c: 08 01 09 6b 	subs	w8, w8, w9
1000033a0: e8 b7 9f 1a 	cset	w8, ge
1000033a4: 08 0b 00 37 	tbnz	w8, #0, 0x100003504 <_Cnn_backward+0x1d0>
1000033a8: 01 00 00 14 	b	0x1000033ac <_Cnn_backward+0x78>
1000033ac: e0 1b 40 fd 	ldr	d0, [sp, #48]
1000033b0: e8 27 40 f9 	ldr	x8, [sp, #72]
1000033b4: 08 11 40 f9 	ldr	x8, [x8, #32]
1000033b8: e9 2f 80 b9 	ldrsw	x9, [sp, #44]
1000033bc: 01 79 69 fc 	ldr	d1, [x8, x9, lsl #3]
1000033c0: 00 08 61 1e 	fmul	d0, d0, d1
1000033c4: e0 13 00 fd 	str	d0, [sp, #32]
1000033c8: e0 1b 40 fd 	ldr	d0, [sp, #48]
1000033cc: e8 27 40 f9 	ldr	x8, [sp, #72]
1000033d0: 08 15 40 f9 	ldr	x8, [x8, #40]
1000033d4: e9 2f 80 b9 	ldrsw	x9, [sp, #44]
1000033d8: 01 79 69 fc 	ldr	d1, [x8, x9, lsl #3]
1000033dc: 00 08 61 1e 	fmul	d0, d0, d1
1000033e0: e8 27 40 f9 	ldr	x8, [sp, #72]
1000033e4: 08 11 40 f9 	ldr	x8, [x8, #32]
1000033e8: e9 2f 80 b9 	ldrsw	x9, [sp, #44]
1000033ec: 01 79 69 fc 	ldr	d1, [x8, x9, lsl #3]
1000033f0: 00 08 61 1e 	fmul	d0, d0, d1
1000033f4: e8 27 40 f9 	ldr	x8, [sp, #72]
1000033f8: 08 11 40 f9 	ldr	x8, [x8, #32]
1000033fc: e9 2f 80 b9 	ldrsw	x9, [sp, #44]
100003400: 02 79 69 fc 	ldr	d2, [x8, x9, lsl #3]
100003404: 01 10 6e 1e 	fmov	d1, #1.00000000
100003408: 21 38 62 1e 	fsub	d1, d1, d2
10000340c: 00 08 61 1e 	fmul	d0, d0, d1
100003410: e0 0f 00 fd 	str	d0, [sp, #24]
100003414: e8 27 40 f9 	ldr	x8, [sp, #72]
100003418: 00 05 40 fd 	ldr	d0, [x8, #8]
10000341c: e1 13 40 fd 	ldr	d1, [sp, #32]
100003420: e8 27 40 f9 	ldr	x8, [sp, #72]
100003424: 08 15 40 f9 	ldr	x8, [x8, #40]
100003428: e9 2f 80 b9 	ldrsw	x9, [sp, #44]
10000342c: 08 0d 09 8b 	add	x8, x8, x9, lsl #3
100003430: 02 01 40 fd 	ldr	d2, [x8]
100003434: 00 88 41 1f 	fmsub	d0, d0, d1, d2
100003438: 00 01 00 fd 	str	d0, [x8]
10000343c: e8 27 40 f9 	ldr	x8, [sp, #72]
100003440: 00 05 40 fd 	ldr	d0, [x8, #8]
100003444: e1 0f 40 fd 	ldr	d1, [sp, #24]
100003448: e8 27 40 f9 	ldr	x8, [sp, #72]
10000344c: 08 0d 40 f9 	ldr	x8, [x8, #24]
100003450: e9 2f 80 b9 	ldrsw	x9, [sp, #44]
100003454: 08 0d 09 8b 	add	x8, x8, x9, lsl #3
100003458: 02 01 40 fd 	ldr	d2, [x8]
10000345c: 00 88 41 1f 	fmsub	d0, d0, d1, d2
100003460: 00 01 00 fd 	str	d0, [x8]
100003464: ff 17 00 b9 	str	wzr, [sp, #20]
100003468: 01 00 00 14 	b	0x10000346c <_Cnn_backward+0x138>
10000346c: e8 17 40 b9 	ldr	w8, [sp, #20]
100003470: e9 27 40 f9 	ldr	x9, [sp, #72]
100003474: 29 01 40 b9 	ldr	w9, [x9]
100003478: 08 01 09 6b 	subs	w8, w8, w9
10000347c: e8 b7 9f 1a 	cset	w8, ge
100003480: 88 03 00 37 	tbnz	w8, #0, 0x1000034f0 <_Cnn_backward+0x1bc>
100003484: 01 00 00 14 	b	0x100003488 <_Cnn_backward+0x154>
100003488: e8 23 40 f9 	ldr	x8, [sp, #64]
10000348c: e9 17 80 b9 	ldrsw	x9, [sp, #20]
100003490: 00 79 69 fc 	ldr	d0, [x8, x9, lsl #3]
100003494: e1 0f 40 fd 	ldr	d1, [sp, #24]
100003498: 00 08 61 1e 	fmul	d0, d0, d1
10000349c: e0 07 00 fd 	str	d0, [sp, #8]
1000034a0: e8 27 40 f9 	ldr	x8, [sp, #72]
1000034a4: 00 05 40 fd 	ldr	d0, [x8, #8]
1000034a8: e1 07 40 fd 	ldr	d1, [sp, #8]
1000034ac: e8 27 40 f9 	ldr	x8, [sp, #72]
1000034b0: 08 09 40 f9 	ldr	x8, [x8, #16]
1000034b4: e9 17 40 b9 	ldr	w9, [sp, #20]
1000034b8: ea 27 40 f9 	ldr	x10, [sp, #72]
1000034bc: 4a 05 40 b9 	ldr	w10, [x10, #4]
1000034c0: 29 7d 0a 1b 	mul	w9, w9, w10
1000034c4: ea 2f 40 b9 	ldr	w10, [sp, #44]
1000034c8: 29 01 0a 0b 	add	w9, w9, w10
1000034cc: 08 cd 29 8b 	add	x8, x8, w9, sxtw #3
1000034d0: 02 01 40 fd 	ldr	d2, [x8]
1000034d4: 00 88 41 1f 	fmsub	d0, d0, d1, d2
1000034d8: 00 01 00 fd 	str	d0, [x8]
1000034dc: 01 00 00 14 	b	0x1000034e0 <_Cnn_backward+0x1ac>
1000034e0: e8 17 40 b9 	ldr	w8, [sp, #20]
1000034e4: 08 05 00 11 	add	w8, w8, #1
1000034e8: e8 17 00 b9 	str	w8, [sp, #20]
1000034ec: e0 ff ff 17 	b	0x10000346c <_Cnn_backward+0x138>
1000034f0: 01 00 00 14 	b	0x1000034f4 <_Cnn_backward+0x1c0>
1000034f4: e8 2f 40 b9 	ldr	w8, [sp, #44]
1000034f8: 08 05 00 11 	add	w8, w8, #1
1000034fc: e8 2f 00 b9 	str	w8, [sp, #44]
100003500: a4 ff ff 17 	b	0x100003390 <_Cnn_backward+0x5c>
100003504: ff 43 01 91 	add	sp, sp, #80
100003508: c0 03 5f d6 	ret

000000010000350c <_Cnn_average_loss>:
10000350c: ff 03 01 d1 	sub	sp, sp, #64
100003510: fd 7b 03 a9 	stp	x29, x30, [sp, #48]
100003514: fd c3 00 91 	add	x29, sp, #48
100003518: a0 83 1f f8 	stur	x0, [x29, #-8]
10000351c: a1 03 1f f8 	stur	x1, [x29, #-16]
100003520: 00 e4 00 2f 	movi	d0, #0000000000000000
100003524: e0 0f 00 fd 	str	d0, [sp, #24]
100003528: ff 17 00 b9 	str	wzr, [sp, #20]
10000352c: 01 00 00 14 	b	0x100003530 <_Cnn_average_loss+0x24>
100003530: e8 17 40 b9 	ldr	w8, [sp, #20]
100003534: a9 03 5f f8 	ldur	x9, [x29, #-16]
100003538: 29 09 40 b9 	ldr	w9, [x9, #8]
10000353c: 08 01 09 6b 	subs	w8, w8, w9
100003540: e8 b7 9f 1a 	cset	w8, ge
100003544: e8 03 00 37 	tbnz	w8, #0, 0x1000035c0 <_Cnn_average_loss+0xb4>
100003548: 01 00 00 14 	b	0x10000354c <_Cnn_average_loss+0x40>
10000354c: a0 83 5f f8 	ldur	x0, [x29, #-8]
100003550: a8 03 5f f8 	ldur	x8, [x29, #-16]
100003554: 08 01 40 f9 	ldr	x8, [x8]
100003558: e9 17 80 b9 	ldrsw	x9, [sp, #20]
10000355c: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
100003560: 01 05 40 f9 	ldr	x1, [x8, #8]
100003564: fd fe ff 97 	bl	0x100003158 <_Cnn_forward>
100003568: e0 07 00 fd 	str	d0, [sp, #8]
10000356c: a8 03 5f f8 	ldur	x8, [x29, #-16]
100003570: 08 01 40 f9 	ldr	x8, [x8]
100003574: e9 17 80 b9 	ldrsw	x9, [sp, #20]
100003578: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
10000357c: 01 01 40 bd 	ldr	s1, [x8]
100003580: 20 40 20 1e 	fmov	s0, s1
100003584: 00 a4 20 0f 	sshll.2d	v0, v0, #0
100003588: 00 d8 61 5e 	scvtf	d0, d0
10000358c: e1 07 40 fd 	ldr	d1, [sp, #8]
100003590: 00 38 61 1e 	fsub	d0, d0, d1
100003594: e0 03 00 fd 	str	d0, [sp]
100003598: e0 03 40 fd 	ldr	d0, [sp]
10000359c: e1 03 40 fd 	ldr	d1, [sp]
1000035a0: e2 0f 40 fd 	ldr	d2, [sp, #24]
1000035a4: 00 08 41 1f 	fmadd	d0, d0, d1, d2
1000035a8: e0 0f 00 fd 	str	d0, [sp, #24]
1000035ac: 01 00 00 14 	b	0x1000035b0 <_Cnn_average_loss+0xa4>
1000035b0: e8 17 40 b9 	ldr	w8, [sp, #20]
1000035b4: 08 05 00 11 	add	w8, w8, #1
1000035b8: e8 17 00 b9 	str	w8, [sp, #20]
1000035bc: dd ff ff 17 	b	0x100003530 <_Cnn_average_loss+0x24>
1000035c0: e0 0f 40 fd 	ldr	d0, [sp, #24]
1000035c4: a8 03 5f f8 	ldur	x8, [x29, #-16]
1000035c8: 02 09 40 bd 	ldr	s2, [x8, #8]
1000035cc: 41 40 20 1e 	fmov	s1, s2
1000035d0: 21 a4 20 0f 	sshll.2d	v1, v1, #0
1000035d4: 21 d8 61 5e 	scvtf	d1, d1
1000035d8: 00 18 61 1e 	fdiv	d0, d0, d1
1000035dc: fd 7b 43 a9 	ldp	x29, x30, [sp, #48]
1000035e0: ff 03 01 91 	add	sp, sp, #64
1000035e4: c0 03 5f d6 	ret

00000001000035e8 <_Cnn_train>:
1000035e8: ff c3 01 d1 	sub	sp, sp, #112
1000035ec: fd 7b 06 a9 	stp	x29, x30, [sp, #96]
1000035f0: fd 83 01 91 	add	x29, sp, #96
1000035f4: 08 00 00 b0 	adrp	x8, 0x100004000 <_Cnn_train+0x10>
1000035f8: 08 05 40 f9 	ldr	x8, [x8, #8]
1000035fc: 08 01 40 f9 	ldr	x8, [x8]
100003600: a8 83 1f f8 	stur	x8, [x29, #-8]
100003604: e0 1b 00 f9 	str	x0, [sp, #48]
100003608: e1 17 00 f9 	str	x1, [sp, #40]
10000360c: e2 27 00 b9 	str	w2, [sp, #36]
100003610: ff 1f 00 b9 	str	wzr, [sp, #28]
100003614: 01 00 00 14 	b	0x100003618 <_Cnn_train+0x30>
100003618: e8 1f 40 b9 	ldr	w8, [sp, #28]
10000361c: e9 27 40 b9 	ldr	w9, [sp, #36]
100003620: 08 01 09 6b 	subs	w8, w8, w9
100003624: e8 b7 9f 1a 	cset	w8, ge
100003628: 48 0a 00 37 	tbnz	w8, #0, 0x100003770 <_Cnn_train+0x188>
10000362c: 01 00 00 14 	b	0x100003630 <_Cnn_train+0x48>
100003630: ff 1b 00 b9 	str	wzr, [sp, #24]
100003634: 01 00 00 14 	b	0x100003638 <_Cnn_train+0x50>
100003638: e8 1b 40 b9 	ldr	w8, [sp, #24]
10000363c: e9 17 40 f9 	ldr	x9, [sp, #40]
100003640: 29 09 40 b9 	ldr	w9, [x9, #8]
100003644: 08 01 09 6b 	subs	w8, w8, w9
100003648: e8 b7 9f 1a 	cset	w8, ge
10000364c: 48 03 00 37 	tbnz	w8, #0, 0x1000036b4 <_Cnn_train+0xcc>
100003650: 01 00 00 14 	b	0x100003654 <_Cnn_train+0x6c>
100003654: e0 1b 40 f9 	ldr	x0, [sp, #48]
100003658: e8 17 40 f9 	ldr	x8, [sp, #40]
10000365c: 08 01 40 f9 	ldr	x8, [x8]
100003660: e9 1b 80 b9 	ldrsw	x9, [sp, #24]
100003664: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
100003668: 01 05 40 f9 	ldr	x1, [x8, #8]
10000366c: bb fe ff 97 	bl	0x100003158 <_Cnn_forward>
100003670: e0 1b 40 f9 	ldr	x0, [sp, #48]
100003674: e8 17 40 f9 	ldr	x8, [sp, #40]
100003678: 08 01 40 f9 	ldr	x8, [x8]
10000367c: e9 1b 80 b9 	ldrsw	x9, [sp, #24]
100003680: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
100003684: 01 05 40 f9 	ldr	x1, [x8, #8]
100003688: e8 17 40 f9 	ldr	x8, [sp, #40]
10000368c: 08 01 40 f9 	ldr	x8, [x8]
100003690: e9 1b 80 b9 	ldrsw	x9, [sp, #24]
100003694: 08 79 69 f8 	ldr	x8, [x8, x9, lsl #3]
100003698: 02 01 40 b9 	ldr	w2, [x8]
10000369c: 26 ff ff 97 	bl	0x100003334 <_Cnn_backward>
1000036a0: 01 00 00 14 	b	0x1000036a4 <_Cnn_train+0xbc>
1000036a4: e8 1b 40 b9 	ldr	w8, [sp, #24]
1000036a8: 08 05 00 11 	add	w8, w8, #1
1000036ac: e8 1b 00 b9 	str	w8, [sp, #24]
1000036b0: e2 ff ff 17 	b	0x100003638 <_Cnn_train+0x50>
1000036b4: e0 1b 40 f9 	ldr	x0, [sp, #48]
1000036b8: e1 17 40 f9 	ldr	x1, [sp, #40]
1000036bc: 94 ff ff 97 	bl	0x10000350c <_Cnn_average_loss>
1000036c0: e0 0b 00 fd 	str	d0, [sp, #16]
1000036c4: 20 00 80 52 	mov	w0, #1
1000036c8: e0 0f 00 b9 	str	w0, [sp, #12]
1000036cc: 01 00 00 90 	adrp	x1, 0x100003000 <_Cnn_train+0xe4>
1000036d0: 21 9c 3c 91 	add	x1, x1, #3879
1000036d4: c2 00 80 d2 	mov	x2, #6
1000036d8: de 01 00 94 	bl	0x100003e50 <_write+0x100003e50>
1000036dc: e1 1f 40 b9 	ldr	w1, [sp, #28]
1000036e0: a0 a3 00 d1 	sub	x0, x29, #40
1000036e4: e0 03 00 f9 	str	x0, [sp]
1000036e8: e0 00 00 94 	bl	0x100003a68 <_Citoa>
1000036ec: e1 03 40 f9 	ldr	x1, [sp]
1000036f0: e8 03 00 aa 	mov	x8, x0
1000036f4: e0 0f 40 b9 	ldr	w0, [sp, #12]
1000036f8: e8 23 00 b9 	str	w8, [sp, #32]
1000036fc: e2 23 80 b9 	ldrsw	x2, [sp, #32]
100003700: d4 01 00 94 	bl	0x100003e50 <_write+0x100003e50>
100003704: e0 0f 40 b9 	ldr	w0, [sp, #12]
100003708: 01 00 00 90 	adrp	x1, 0x100003000 <_Cnn_train+0x120>
10000370c: 21 b8 3c 91 	add	x1, x1, #3886
100003710: 22 01 80 d2 	mov	x2, #9
100003714: cf 01 00 94 	bl	0x100003e50 <_write+0x100003e50>
100003718: e0 03 40 f9 	ldr	x0, [sp]
10000371c: e0 0b 40 fd 	ldr	d0, [sp, #16]
100003720: 41 01 80 52 	mov	w1, #10
100003724: 23 01 00 94 	bl	0x100003bb0 <_Cdtoa>
100003728: e1 03 40 f9 	ldr	x1, [sp]
10000372c: e8 03 00 aa 	mov	x8, x0
100003730: e0 0f 40 b9 	ldr	w0, [sp, #12]
100003734: e8 23 00 b9 	str	w8, [sp, #32]
100003738: e2 23 80 b9 	ldrsw	x2, [sp, #32]
10000373c: c5 01 00 94 	bl	0x100003e50 <_write+0x100003e50>
100003740: e0 0f 40 b9 	ldr	w0, [sp, #12]
100003744: 01 00 00 90 	adrp	x1, 0x100003000 <_Cnn_train+0x15c>
100003748: 21 fc 3b 91 	add	x1, x1, #3839
10000374c: 22 00 80 d2 	mov	x2, #1
100003750: c0 01 00 94 	bl	0x100003e50 <_write+0x100003e50>
100003754: e0 17 40 f9 	ldr	x0, [sp, #40]
100003758: 0c fc ff 97 	bl	0x100002788 <_Cds_shuffle>
10000375c: 01 00 00 14 	b	0x100003760 <_Cnn_train+0x178>
100003760: e8 1f 40 b9 	ldr	w8, [sp, #28]
100003764: 08 05 00 11 	add	w8, w8, #1
100003768: e8 1f 00 b9 	str	w8, [sp, #28]
10000376c: ab ff ff 17 	b	0x100003618 <_Cnn_train+0x30>
100003770: a9 83 5f f8 	ldur	x9, [x29, #-8]
100003774: 08 00 00 b0 	adrp	x8, 0x100004000 <_Cnn_train+0x190>
100003778: 08 05 40 f9 	ldr	x8, [x8, #8]
10000377c: 08 01 40 f9 	ldr	x8, [x8]
100003780: 08 01 09 eb 	subs	x8, x8, x9
100003784: e8 17 9f 1a 	cset	w8, eq
100003788: 68 00 00 37 	tbnz	w8, #0, 0x100003794 <_Cnn_train+0x1ac>
10000378c: 01 00 00 14 	b	0x100003790 <_Cnn_train+0x1a8>
100003790: 89 01 00 94 	bl	0x100003db4 <_write+0x100003db4>
100003794: fd 7b 46 a9 	ldp	x29, x30, [sp, #96]
100003798: ff c3 01 91 	add	sp, sp, #112
10000379c: c0 03 5f d6 	ret

00000001000037a0 <_Cnn_save>:
1000037a0: ff 03 01 d1 	sub	sp, sp, #64
1000037a4: fd 7b 03 a9 	stp	x29, x30, [sp, #48]
1000037a8: fd c3 00 91 	add	x29, sp, #48
1000037ac: a0 83 1f f8 	stur	x0, [x29, #-8]
1000037b0: a1 03 1f f8 	stur	x1, [x29, #-16]
1000037b4: a0 03 5f f8 	ldur	x0, [x29, #-16]
1000037b8: e9 03 00 91 	mov	x9, sp
1000037bc: 08 38 80 d2 	mov	x8, #448
1000037c0: 28 01 00 f9 	str	x8, [x9]
1000037c4: 21 c0 80 52 	mov	w1, #1537
1000037c8: 93 01 00 94 	bl	0x100003e14 <_write+0x100003e14>
1000037cc: a0 c3 1e b8 	stur	w0, [x29, #-20]
1000037d0: a8 c3 5e b8 	ldur	w8, [x29, #-20]
1000037d4: 08 01 00 71 	subs	w8, w8, #0
1000037d8: e8 b7 9f 1a 	cset	w8, ge
1000037dc: e8 00 00 37 	tbnz	w8, #0, 0x1000037f8 <_Cnn_save+0x58>
1000037e0: 01 00 00 14 	b	0x1000037e4 <_Cnn_save+0x44>
1000037e4: 00 00 00 90 	adrp	x0, 0x100003000 <_Cnn_save+0x44>
1000037e8: 00 e0 3c 91 	add	x0, x0, #3896
1000037ec: 8d 01 00 94 	bl	0x100003e20 <_write+0x100003e20>
1000037f0: 60 00 80 52 	mov	w0, #3
1000037f4: 79 01 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
1000037f8: a0 c3 5e b8 	ldur	w0, [x29, #-20]
1000037fc: a1 83 5f f8 	ldur	x1, [x29, #-8]
100003800: 82 00 80 d2 	mov	x2, #4
100003804: e2 07 00 f9 	str	x2, [sp, #8]
100003808: 92 01 00 94 	bl	0x100003e50 <_write+0x100003e50>
10000380c: e2 07 40 f9 	ldr	x2, [sp, #8]
100003810: a0 c3 5e b8 	ldur	w0, [x29, #-20]
100003814: a8 83 5f f8 	ldur	x8, [x29, #-8]
100003818: 01 11 00 91 	add	x1, x8, #4
10000381c: 8d 01 00 94 	bl	0x100003e50 <_write+0x100003e50>
100003820: a0 c3 5e b8 	ldur	w0, [x29, #-20]
100003824: a8 83 5f f8 	ldur	x8, [x29, #-8]
100003828: 01 21 00 91 	add	x1, x8, #8
10000382c: 02 01 80 d2 	mov	x2, #8
100003830: e2 0b 00 f9 	str	x2, [sp, #16]
100003834: 87 01 00 94 	bl	0x100003e50 <_write+0x100003e50>
100003838: e2 0b 40 f9 	ldr	x2, [sp, #16]
10000383c: a0 c3 5e b8 	ldur	w0, [x29, #-20]
100003840: a8 83 5f f8 	ldur	x8, [x29, #-8]
100003844: 01 c1 00 91 	add	x1, x8, #48
100003848: 82 01 00 94 	bl	0x100003e50 <_write+0x100003e50>
10000384c: a8 83 5f f8 	ldur	x8, [x29, #-8]
100003850: 00 01 40 b9 	ldr	w0, [x8]
100003854: a8 83 5f f8 	ldur	x8, [x29, #-8]
100003858: 01 05 40 b9 	ldr	w1, [x8, #4]
10000385c: 74 fd ff 97 	bl	0x100002e2c <_C_compute_mem_reqs>
100003860: e8 03 00 aa 	mov	x8, x0
100003864: e8 1b 00 b9 	str	w8, [sp, #24]
100003868: a0 c3 5e b8 	ldur	w0, [x29, #-20]
10000386c: a8 83 5f f8 	ldur	x8, [x29, #-8]
100003870: 01 09 40 f9 	ldr	x1, [x8, #16]
100003874: e2 1b 80 b9 	ldrsw	x2, [sp, #24]
100003878: 76 01 00 94 	bl	0x100003e50 <_write+0x100003e50>
10000387c: a0 c3 5e b8 	ldur	w0, [x29, #-20]
100003880: 53 01 00 94 	bl	0x100003dcc <_write+0x100003dcc>
100003884: fd 7b 43 a9 	ldp	x29, x30, [sp, #48]
100003888: ff 03 01 91 	add	sp, sp, #64
10000388c: c0 03 5f d6 	ret

0000000100003890 <_Cnn_load>:
100003890: ff c3 03 d1 	sub	sp, sp, #240
100003894: fd 7b 0e a9 	stp	x29, x30, [sp, #224]
100003898: fd 83 03 91 	add	x29, sp, #224
10000389c: a0 83 1f f8 	stur	x0, [x29, #-8]
1000038a0: a1 03 1f f8 	stur	x1, [x29, #-16]
1000038a4: a0 03 5f f8 	ldur	x0, [x29, #-16]
1000038a8: 01 00 80 52 	mov	w1, #0
1000038ac: 5a 01 00 94 	bl	0x100003e14 <_write+0x100003e14>
1000038b0: a0 c3 1e b8 	stur	w0, [x29, #-20]
1000038b4: a8 c3 5e b8 	ldur	w8, [x29, #-20]
1000038b8: 08 01 00 71 	subs	w8, w8, #0
1000038bc: e8 b7 9f 1a 	cset	w8, ge
1000038c0: e8 00 00 37 	tbnz	w8, #0, 0x1000038dc <_Cnn_load+0x4c>
1000038c4: 01 00 00 14 	b	0x1000038c8 <_Cnn_load+0x38>
1000038c8: 00 00 00 90 	adrp	x0, 0x100003000 <_Cnn_load+0x38>
1000038cc: 00 e4 3a 91 	add	x0, x0, #3769
1000038d0: 54 01 00 94 	bl	0x100003e20 <_write+0x100003e20>
1000038d4: 80 00 80 52 	mov	w0, #4
1000038d8: 40 01 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
1000038dc: a0 c3 5e b8 	ldur	w0, [x29, #-20]
1000038e0: e1 e3 00 91 	add	x1, sp, #56
1000038e4: 43 01 00 94 	bl	0x100003df0 <_write+0x100003df0>
1000038e8: e0 37 00 b9 	str	w0, [sp, #52]
1000038ec: e8 37 40 b9 	ldr	w8, [sp, #52]
1000038f0: 08 01 00 71 	subs	w8, w8, #0
1000038f4: e8 b7 9f 1a 	cset	w8, ge
1000038f8: e8 00 00 37 	tbnz	w8, #0, 0x100003914 <_Cnn_load+0x84>
1000038fc: 01 00 00 14 	b	0x100003900 <_Cnn_load+0x70>
100003900: 00 00 00 90 	adrp	x0, 0x100003000 <_Cnn_load+0x70>
100003904: 00 f8 3a 91 	add	x0, x0, #3774
100003908: 46 01 00 94 	bl	0x100003e20 <_write+0x100003e20>
10000390c: a0 00 80 52 	mov	w0, #5
100003910: 32 01 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
100003914: e1 4f 40 f9 	ldr	x1, [sp, #152]
100003918: a4 c3 5e b8 	ldur	w4, [x29, #-20]
10000391c: 00 00 80 d2 	mov	x0, #0
100003920: 22 00 80 52 	mov	w2, #1
100003924: 43 00 80 52 	mov	w3, #2
100003928: 05 00 80 d2 	mov	x5, #0
10000392c: 34 01 00 94 	bl	0x100003dfc <_write+0x100003dfc>
100003930: e0 17 00 f9 	str	x0, [sp, #40]
100003934: e8 17 40 f9 	ldr	x8, [sp, #40]
100003938: 08 05 00 b1 	adds	x8, x8, #1
10000393c: e8 07 9f 1a 	cset	w8, ne
100003940: e8 00 00 37 	tbnz	w8, #0, 0x10000395c <_Cnn_load+0xcc>
100003944: 01 00 00 14 	b	0x100003948 <_Cnn_load+0xb8>
100003948: 00 00 00 90 	adrp	x0, 0x100003000 <_Cnn_load+0xb8>
10000394c: 00 10 3b 91 	add	x0, x0, #3780
100003950: 37 01 00 94 	bl	0x100003e2c <_write+0x100003e2c>
100003954: c0 00 80 52 	mov	w0, #6
100003958: 20 01 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
10000395c: e8 17 40 f9 	ldr	x8, [sp, #40]
100003960: 08 01 40 b9 	ldr	w8, [x8]
100003964: e8 27 00 b9 	str	w8, [sp, #36]
100003968: e8 17 40 f9 	ldr	x8, [sp, #40]
10000396c: 08 05 40 b9 	ldr	w8, [x8, #4]
100003970: e8 23 00 b9 	str	w8, [sp, #32]
100003974: e8 17 40 f9 	ldr	x8, [sp, #40]
100003978: 00 05 40 fd 	ldr	d0, [x8, #8]
10000397c: e0 0f 00 fd 	str	d0, [sp, #24]
100003980: e8 17 40 f9 	ldr	x8, [sp, #40]
100003984: 00 09 40 fd 	ldr	d0, [x8, #16]
100003988: e0 0b 00 fd 	str	d0, [sp, #16]
10000398c: e8 17 40 f9 	ldr	x8, [sp, #40]
100003990: 08 61 00 91 	add	x8, x8, #24
100003994: e8 07 00 f9 	str	x8, [sp, #8]
100003998: a0 83 5f f8 	ldur	x0, [x29, #-8]
10000399c: e1 27 40 b9 	ldr	w1, [sp, #36]
1000039a0: e2 23 40 b9 	ldr	w2, [sp, #32]
1000039a4: e0 0f 40 fd 	ldr	d0, [sp, #24]
1000039a8: 8b fd ff 97 	bl	0x100002fd4 <_Cnn_init>
1000039ac: e0 0b 40 fd 	ldr	d0, [sp, #16]
1000039b0: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000039b4: 00 19 00 fd 	str	d0, [x8, #48]
1000039b8: e8 23 40 b9 	ldr	w8, [sp, #32]
1000039bc: e9 27 40 b9 	ldr	w9, [sp, #36]
1000039c0: 29 0d 00 11 	add	w9, w9, #3
1000039c4: 08 7d 09 1b 	mul	w8, w8, w9
1000039c8: e8 07 00 b9 	str	w8, [sp, #4]
1000039cc: ff 03 00 b9 	str	wzr, [sp]
1000039d0: 01 00 00 14 	b	0x1000039d4 <_Cnn_load+0x144>
1000039d4: e8 03 40 b9 	ldr	w8, [sp]
1000039d8: e9 07 40 b9 	ldr	w9, [sp, #4]
1000039dc: 08 01 09 6b 	subs	w8, w8, w9
1000039e0: e8 b7 9f 1a 	cset	w8, ge
1000039e4: c8 01 00 37 	tbnz	w8, #0, 0x100003a1c <_Cnn_load+0x18c>
1000039e8: 01 00 00 14 	b	0x1000039ec <_Cnn_load+0x15c>
1000039ec: e8 07 40 f9 	ldr	x8, [sp, #8]
1000039f0: e9 03 80 b9 	ldrsw	x9, [sp]
1000039f4: 00 79 69 fc 	ldr	d0, [x8, x9, lsl #3]
1000039f8: a8 83 5f f8 	ldur	x8, [x29, #-8]
1000039fc: 08 09 40 f9 	ldr	x8, [x8, #16]
100003a00: e9 03 80 b9 	ldrsw	x9, [sp]
100003a04: 00 79 29 fc 	str	d0, [x8, x9, lsl #3]
100003a08: 01 00 00 14 	b	0x100003a0c <_Cnn_load+0x17c>
100003a0c: e8 03 40 b9 	ldr	w8, [sp]
100003a10: 08 05 00 11 	add	w8, w8, #1
100003a14: e8 03 00 b9 	str	w8, [sp]
100003a18: ef ff ff 17 	b	0x1000039d4 <_Cnn_load+0x144>
100003a1c: e0 17 40 f9 	ldr	x0, [sp, #40]
100003a20: e1 4f 40 f9 	ldr	x1, [sp, #152]
100003a24: f9 00 00 94 	bl	0x100003e08 <_write+0x100003e08>
100003a28: e0 37 00 b9 	str	w0, [sp, #52]
100003a2c: e8 37 40 b9 	ldr	w8, [sp, #52]
100003a30: 08 01 00 71 	subs	w8, w8, #0
100003a34: e8 17 9f 1a 	cset	w8, eq
100003a38: e8 00 00 37 	tbnz	w8, #0, 0x100003a54 <_Cnn_load+0x1c4>
100003a3c: 01 00 00 14 	b	0x100003a40 <_Cnn_load+0x1b0>
100003a40: 00 00 00 90 	adrp	x0, 0x100003000 <_Cnn_load+0x1b0>
100003a44: 00 00 3d 91 	add	x0, x0, #3904
100003a48: f6 00 00 94 	bl	0x100003e20 <_write+0x100003e20>
100003a4c: e0 00 80 52 	mov	w0, #7
100003a50: e2 00 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
100003a54: a0 c3 5e b8 	ldur	w0, [x29, #-20]
100003a58: dd 00 00 94 	bl	0x100003dcc <_write+0x100003dcc>
100003a5c: fd 7b 4e a9 	ldp	x29, x30, [sp, #224]
100003a60: ff c3 03 91 	add	sp, sp, #240
100003a64: c0 03 5f d6 	ret

0000000100003a68 <_Citoa>:
100003a68: ff 83 00 d1 	sub	sp, sp, #32
100003a6c: e0 0b 00 f9 	str	x0, [sp, #16]
100003a70: e1 0f 00 b9 	str	w1, [sp, #12]
100003a74: ff 0b 00 b9 	str	wzr, [sp, #8]
100003a78: e8 0f 40 b9 	ldr	w8, [sp, #12]
100003a7c: 08 01 00 71 	subs	w8, w8, #0
100003a80: e8 07 9f 1a 	cset	w8, ne
100003a84: 08 01 00 37 	tbnz	w8, #0, 0x100003aa4 <_Citoa+0x3c>
100003a88: 01 00 00 14 	b	0x100003a8c <_Citoa+0x24>
100003a8c: e9 0b 40 f9 	ldr	x9, [sp, #16]
100003a90: 08 06 80 52 	mov	w8, #48
100003a94: 28 01 00 39 	strb	w8, [x9]
100003a98: 28 00 80 52 	mov	w8, #1
100003a9c: e8 1f 00 b9 	str	w8, [sp, #28]
100003aa0: 41 00 00 14 	b	0x100003ba4 <_Citoa+0x13c>
100003aa4: 01 00 00 14 	b	0x100003aa8 <_Citoa+0x40>
100003aa8: e8 0f 40 b9 	ldr	w8, [sp, #12]
100003aac: 08 01 00 71 	subs	w8, w8, #0
100003ab0: e8 c7 9f 1a 	cset	w8, le
100003ab4: 48 02 00 37 	tbnz	w8, #0, 0x100003afc <_Citoa+0x94>
100003ab8: 01 00 00 14 	b	0x100003abc <_Citoa+0x54>
100003abc: e8 0f 40 b9 	ldr	w8, [sp, #12]
100003ac0: 49 01 80 52 	mov	w9, #10
100003ac4: 0a 0d c9 1a 	sdiv	w10, w8, w9
100003ac8: 4a 7d 09 1b 	mul	w10, w10, w9
100003acc: 08 01 0a 6b 	subs	w8, w8, w10
100003ad0: 08 c1 00 11 	add	w8, w8, #48
100003ad4: ea 0b 40 f9 	ldr	x10, [sp, #16]
100003ad8: eb 0b 80 b9 	ldrsw	x11, [sp, #8]
100003adc: 48 69 2b 38 	strb	w8, [x10, x11]
100003ae0: e8 0f 40 b9 	ldr	w8, [sp, #12]
100003ae4: 08 0d c9 1a 	sdiv	w8, w8, w9
100003ae8: e8 0f 00 b9 	str	w8, [sp, #12]
100003aec: e8 0b 40 b9 	ldr	w8, [sp, #8]
100003af0: 08 05 00 11 	add	w8, w8, #1
100003af4: e8 0b 00 b9 	str	w8, [sp, #8]
100003af8: ec ff ff 17 	b	0x100003aa8 <_Citoa+0x40>
100003afc: ff 07 00 b9 	str	wzr, [sp, #4]
100003b00: 01 00 00 14 	b	0x100003b04 <_Citoa+0x9c>
100003b04: e8 07 40 b9 	ldr	w8, [sp, #4]
100003b08: e9 0b 40 b9 	ldr	w9, [sp, #8]
100003b0c: 4a 00 80 52 	mov	w10, #2
100003b10: 29 0d ca 1a 	sdiv	w9, w9, w10
100003b14: 08 01 09 6b 	subs	w8, w8, w9
100003b18: e8 b7 9f 1a 	cset	w8, ge
100003b1c: e8 03 00 37 	tbnz	w8, #0, 0x100003b98 <_Citoa+0x130>
100003b20: 01 00 00 14 	b	0x100003b24 <_Citoa+0xbc>
100003b24: e8 0b 40 f9 	ldr	x8, [sp, #16]
100003b28: e9 07 80 b9 	ldrsw	x9, [sp, #4]
100003b2c: 08 01 09 8b 	add	x8, x8, x9
100003b30: 08 01 40 39 	ldrb	w8, [x8]
100003b34: e8 0f 00 39 	strb	w8, [sp, #3]
100003b38: e8 0b 40 f9 	ldr	x8, [sp, #16]
100003b3c: e9 0b 40 b9 	ldr	w9, [sp, #8]
100003b40: ea 07 40 b9 	ldr	w10, [sp, #4]
100003b44: 29 01 0a 6b 	subs	w9, w9, w10
100003b48: 29 05 00 71 	subs	w9, w9, #1
100003b4c: 08 c1 29 8b 	add	x8, x8, w9, sxtw
100003b50: 08 01 40 39 	ldrb	w8, [x8]
100003b54: e9 0b 40 f9 	ldr	x9, [sp, #16]
100003b58: ea 07 80 b9 	ldrsw	x10, [sp, #4]
100003b5c: 29 01 0a 8b 	add	x9, x9, x10
100003b60: 28 01 00 39 	strb	w8, [x9]
100003b64: e8 0f 40 39 	ldrb	w8, [sp, #3]
100003b68: e9 0b 40 f9 	ldr	x9, [sp, #16]
100003b6c: ea 0b 40 b9 	ldr	w10, [sp, #8]
100003b70: eb 07 40 b9 	ldr	w11, [sp, #4]
100003b74: 4a 01 0b 6b 	subs	w10, w10, w11
100003b78: 4a 05 00 71 	subs	w10, w10, #1
100003b7c: 29 c1 2a 8b 	add	x9, x9, w10, sxtw
100003b80: 28 01 00 39 	strb	w8, [x9]
100003b84: 01 00 00 14 	b	0x100003b88 <_Citoa+0x120>
100003b88: e8 07 40 b9 	ldr	w8, [sp, #4]
100003b8c: 08 05 00 11 	add	w8, w8, #1
100003b90: e8 07 00 b9 	str	w8, [sp, #4]
100003b94: dc ff ff 17 	b	0x100003b04 <_Citoa+0x9c>
100003b98: e8 0b 40 b9 	ldr	w8, [sp, #8]
100003b9c: e8 1f 00 b9 	str	w8, [sp, #28]
100003ba0: 01 00 00 14 	b	0x100003ba4 <_Citoa+0x13c>
100003ba4: e0 1f 40 b9 	ldr	w0, [sp, #28]
100003ba8: ff 83 00 91 	add	sp, sp, #32
100003bac: c0 03 5f d6 	ret

0000000100003bb0 <_Cdtoa>:
100003bb0: ff 03 01 d1 	sub	sp, sp, #64
100003bb4: fd 7b 03 a9 	stp	x29, x30, [sp, #48]
100003bb8: fd c3 00 91 	add	x29, sp, #48
100003bbc: a0 03 1f f8 	stur	x0, [x29, #-16]
100003bc0: e0 0f 00 fd 	str	d0, [sp, #24]
100003bc4: e1 17 00 b9 	str	w1, [sp, #20]
100003bc8: e0 0f 40 fd 	ldr	d0, [sp, #24]
100003bcc: 08 20 60 1e 	fcmp	d0, #0.0
100003bd0: e8 07 9f 1a 	cset	w8, ne
100003bd4: 08 01 00 37 	tbnz	w8, #0, 0x100003bf4 <_Cdtoa+0x44>
100003bd8: 01 00 00 14 	b	0x100003bdc <_Cdtoa+0x2c>
100003bdc: a9 03 5f f8 	ldur	x9, [x29, #-16]
100003be0: 08 06 80 52 	mov	w8, #48
100003be4: 28 01 00 39 	strb	w8, [x9]
100003be8: 28 00 80 52 	mov	w8, #1
100003bec: a8 c3 1f b8 	stur	w8, [x29, #-4]
100003bf0: 4e 00 00 14 	b	0x100003d28 <_Cdtoa+0x178>
100003bf4: ff 13 00 b9 	str	wzr, [sp, #16]
100003bf8: e0 0f 40 fd 	ldr	d0, [sp, #24]
100003bfc: 08 20 60 1e 	fcmp	d0, #0.0
100003c00: e8 47 9f 1a 	cset	w8, pl
100003c04: 88 01 00 37 	tbnz	w8, #0, 0x100003c34 <_Cdtoa+0x84>
100003c08: 01 00 00 14 	b	0x100003c0c <_Cdtoa+0x5c>
100003c0c: 28 00 80 52 	mov	w8, #1
100003c10: e8 13 00 b9 	str	w8, [sp, #16]
100003c14: a9 03 5f f8 	ldur	x9, [x29, #-16]
100003c18: a8 05 80 52 	mov	w8, #45
100003c1c: 28 01 00 39 	strb	w8, [x9]
100003c20: e0 0f 40 fd 	ldr	d0, [sp, #24]
100003c24: 01 10 7e 1e 	fmov	d1, #-1.00000000
100003c28: 00 08 61 1e 	fmul	d0, d0, d1
100003c2c: e0 0f 00 fd 	str	d0, [sp, #24]
100003c30: 01 00 00 14 	b	0x100003c34 <_Cdtoa+0x84>
100003c34: a8 03 5f f8 	ldur	x8, [x29, #-16]
100003c38: e9 13 80 b9 	ldrsw	x9, [sp, #16]
100003c3c: 00 01 09 8b 	add	x0, x8, x9
100003c40: e0 0f 40 fd 	ldr	d0, [sp, #24]
100003c44: 01 00 78 1e 	fcvtzs	w1, d0
100003c48: 88 ff ff 97 	bl	0x100003a68 <_Citoa>
100003c4c: e0 0f 00 b9 	str	w0, [sp, #12]
100003c50: e9 13 40 b9 	ldr	w9, [sp, #16]
100003c54: e8 0f 40 b9 	ldr	w8, [sp, #12]
100003c58: 08 01 09 0b 	add	w8, w8, w9
100003c5c: e8 0f 00 b9 	str	w8, [sp, #12]
100003c60: a8 03 5f f8 	ldur	x8, [x29, #-16]
100003c64: e9 0f 80 b9 	ldrsw	x9, [sp, #12]
100003c68: ea 03 09 aa 	mov	x10, x9
100003c6c: 4a 05 00 11 	add	w10, w10, #1
100003c70: ea 0f 00 b9 	str	w10, [sp, #12]
100003c74: 09 01 09 8b 	add	x9, x8, x9
100003c78: c8 05 80 52 	mov	w8, #46
100003c7c: 28 01 00 39 	strb	w8, [x9]
100003c80: e0 0f 40 fd 	ldr	d0, [sp, #24]
100003c84: e1 0f 40 fd 	ldr	d1, [sp, #24]
100003c88: 28 00 78 1e 	fcvtzs	w8, d1
100003c8c: 01 01 62 1e 	scvtf	d1, w8
100003c90: 00 38 61 1e 	fsub	d0, d0, d1
100003c94: e0 0f 00 fd 	str	d0, [sp, #24]
100003c98: ff 0b 00 b9 	str	wzr, [sp, #8]
100003c9c: 01 00 00 14 	b	0x100003ca0 <_Cdtoa+0xf0>
100003ca0: e8 0b 40 b9 	ldr	w8, [sp, #8]
100003ca4: e9 17 40 b9 	ldr	w9, [sp, #20]
100003ca8: 08 01 09 6b 	subs	w8, w8, w9
100003cac: e8 b7 9f 1a 	cset	w8, ge
100003cb0: 68 03 00 37 	tbnz	w8, #0, 0x100003d1c <_Cdtoa+0x16c>
100003cb4: 01 00 00 14 	b	0x100003cb8 <_Cdtoa+0x108>
100003cb8: e0 0f 40 fd 	ldr	d0, [sp, #24]
100003cbc: 01 90 64 1e 	fmov	d1, #10.00000000
100003cc0: 00 08 61 1e 	fmul	d0, d0, d1
100003cc4: e0 0f 00 fd 	str	d0, [sp, #24]
100003cc8: e0 0f 40 fd 	ldr	d0, [sp, #24]
100003ccc: 08 00 78 1e 	fcvtzs	w8, d0
100003cd0: 08 1d 00 13 	sxtb	w8, w8
100003cd4: 08 c1 00 11 	add	w8, w8, #48
100003cd8: a9 03 5f f8 	ldur	x9, [x29, #-16]
100003cdc: ea 0f 80 b9 	ldrsw	x10, [sp, #12]
100003ce0: 28 69 2a 38 	strb	w8, [x9, x10]
100003ce4: e8 0f 40 b9 	ldr	w8, [sp, #12]
100003ce8: 08 05 00 11 	add	w8, w8, #1
100003cec: e8 0f 00 b9 	str	w8, [sp, #12]
100003cf0: e0 0f 40 fd 	ldr	d0, [sp, #24]
100003cf4: e1 0f 40 fd 	ldr	d1, [sp, #24]
100003cf8: 28 00 78 1e 	fcvtzs	w8, d1
100003cfc: 01 01 62 1e 	scvtf	d1, w8
100003d00: 00 38 61 1e 	fsub	d0, d0, d1
100003d04: e0 0f 00 fd 	str	d0, [sp, #24]
100003d08: 01 00 00 14 	b	0x100003d0c <_Cdtoa+0x15c>
100003d0c: e8 0b 40 b9 	ldr	w8, [sp, #8]
100003d10: 08 05 00 11 	add	w8, w8, #1
100003d14: e8 0b 00 b9 	str	w8, [sp, #8]
100003d18: e2 ff ff 17 	b	0x100003ca0 <_Cdtoa+0xf0>
100003d1c: e8 0f 40 b9 	ldr	w8, [sp, #12]
100003d20: a8 c3 1f b8 	stur	w8, [x29, #-4]
100003d24: 01 00 00 14 	b	0x100003d28 <_Cdtoa+0x178>
100003d28: a0 c3 5f b8 	ldur	w0, [x29, #-4]
100003d2c: fd 7b 43 a9 	ldp	x29, x30, [sp, #48]
100003d30: ff 03 01 91 	add	sp, sp, #64
100003d34: c0 03 5f d6 	ret

0000000100003d38 <_Cseed>:
100003d38: ff 83 00 d1 	sub	sp, sp, #32
100003d3c: fd 7b 01 a9 	stp	x29, x30, [sp, #16]
100003d40: fd 43 00 91 	add	x29, sp, #16
100003d44: 00 00 80 52 	mov	w0, #0
100003d48: e1 03 00 91 	mov	x1, sp
100003d4c: 1d 00 00 94 	bl	0x100003dc0 <_write+0x100003dc0>
100003d50: 08 04 00 31 	adds	w8, w0, #1
100003d54: e8 07 9f 1a 	cset	w8, ne
100003d58: e8 00 00 37 	tbnz	w8, #0, 0x100003d74 <_Cseed+0x3c>
100003d5c: 01 00 00 14 	b	0x100003d60 <_Cseed+0x28>
100003d60: 00 00 00 90 	adrp	x0, 0x100003000 <_Cseed+0x28>
100003d64: 00 3c 3d 91 	add	x0, x0, #3919
100003d68: 2e 00 00 94 	bl	0x100003e20 <_write+0x100003e20>
100003d6c: 20 00 80 52 	mov	w0, #1
100003d70: 1a 00 00 94 	bl	0x100003dd8 <_write+0x100003dd8>
100003d74: e8 03 40 f9 	ldr	x8, [sp]
100003d78: e0 03 08 aa 	mov	x0, x8
100003d7c: 32 00 00 94 	bl	0x100003e44 <_write+0x100003e44>
100003d80: fd 7b 41 a9 	ldp	x29, x30, [sp, #16]
100003d84: ff 83 00 91 	add	sp, sp, #32
100003d88: c0 03 5f d6 	ret

0000000100003d8c <_ds_destroy>:
100003d8c: 00 08 40 b9 	ldr	w0, [x0, #8]
100003d90: 01 01 80 52 	mov	w1, #8
100003d94: 21 7c 00 1b 	mul	w1, w1, w0
100003d98: 30 09 80 d2 	mov	x16, #73
100003d9c: 01 10 00 d4 	svc	#0x80
100003da0: 40 00 00 34 	cbz	w0, 0x100003da8 <ds_destroy_exit>
100003da4: c0 03 5f d6 	ret

0000000100003da8 <ds_destroy_exit>:
100003da8: 00 01 80 d2 	mov	x0, #8
100003dac: 30 00 80 d2 	mov	x16, #1
100003db0: 01 10 00 d4 	svc	#0x80

Disassembly of section __TEXT,__stubs:

0000000100003db4 <__stubs>:
100003db4: 10 00 00 b0 	adrp	x16, 0x100004000 <__stubs+0x4>
100003db8: 10 02 40 f9 	ldr	x16, [x16]
100003dbc: 00 02 1f d6 	br	x16
100003dc0: 10 00 00 b0 	adrp	x16, 0x100004000 <__stubs+0x10>
100003dc4: 10 0a 40 f9 	ldr	x16, [x16, #16]
100003dc8: 00 02 1f d6 	br	x16
100003dcc: 10 00 00 b0 	adrp	x16, 0x100004000 <__stubs+0x1c>
100003dd0: 10 0e 40 f9 	ldr	x16, [x16, #24]
100003dd4: 00 02 1f d6 	br	x16
100003dd8: 10 00 00 b0 	adrp	x16, 0x100004000 <__stubs+0x28>
100003ddc: 10 12 40 f9 	ldr	x16, [x16, #32]
100003de0: 00 02 1f d6 	br	x16
100003de4: 10 00 00 b0 	adrp	x16, 0x100004000 <__stubs+0x34>
100003de8: 10 16 40 f9 	ldr	x16, [x16, #40]
100003dec: 00 02 1f d6 	br	x16
100003df0: 10 00 00 b0 	adrp	x16, 0x100004000 <__stubs+0x40>
100003df4: 10 1a 40 f9 	ldr	x16, [x16, #48]
100003df8: 00 02 1f d6 	br	x16
100003dfc: 10 00 00 b0 	adrp	x16, 0x100004000 <__stubs+0x4c>
100003e00: 10 1e 40 f9 	ldr	x16, [x16, #56]
100003e04: 00 02 1f d6 	br	x16
100003e08: 10 00 00 b0 	adrp	x16, 0x100004000 <__stubs+0x58>
100003e0c: 10 22 40 f9 	ldr	x16, [x16, #64]
100003e10: 00 02 1f d6 	br	x16
100003e14: 10 00 00 b0 	adrp	x16, 0x100004000 <__stubs+0x64>
100003e18: 10 26 40 f9 	ldr	x16, [x16, #72]
100003e1c: 00 02 1f d6 	br	x16
100003e20: 10 00 00 b0 	adrp	x16, 0x100004000 <__stubs+0x70>
100003e24: 10 2a 40 f9 	ldr	x16, [x16, #80]
100003e28: 00 02 1f d6 	br	x16
100003e2c: 10 00 00 b0 	adrp	x16, 0x100004000 <__stubs+0x7c>
100003e30: 10 2e 40 f9 	ldr	x16, [x16, #88]
100003e34: 00 02 1f d6 	br	x16
100003e38: 10 00 00 b0 	adrp	x16, 0x100004000 <__stubs+0x88>
100003e3c: 10 32 40 f9 	ldr	x16, [x16, #96]
100003e40: 00 02 1f d6 	br	x16
100003e44: 10 00 00 b0 	adrp	x16, 0x100004000 <__stubs+0x94>
100003e48: 10 36 40 f9 	ldr	x16, [x16, #104]
100003e4c: 00 02 1f d6 	br	x16
100003e50: 10 00 00 b0 	adrp	x16, 0x100004000 <__stubs+0xa0>
100003e54: 10 3a 40 f9 	ldr	x16, [x16, #112]
100003e58: 00 02 1f d6 	br	x16
