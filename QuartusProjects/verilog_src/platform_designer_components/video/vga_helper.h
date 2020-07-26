#ifndef _VGA_HELPER_H
#define _VGA_HELPER_H

#define _RED 0xf800
#define _GREEN 0x7e0
#define _BLUE 0x1f
#define _WHITE 0xffff

alt_u32 ch_xpos = 0, ch_ypos = 0;

void put_pixel(alt_u16* base, alt_u32 x, alt_u32 y, alt_u32 rgb) {
	IOWR_16DIRECT(base, (x + (y * XRES)) * 2, (rgb & 0xffff));
}

int get_pixel(alt_u16* base, int x, int y) {
	return IORD_16DIRECT(base, (x + (y * XRES)) * 2);
}

void plot_line(alt_u16* base, int x, int y, int x2, int y2, int rgb) {
	int yLonger=0;
	int shortLen=y2-y;
	int longLen=x2-x;
	int j, swap;
	int decInc;

	if (abs(shortLen) > abs(longLen)) {
		swap = shortLen;
		shortLen = longLen;
		longLen = swap;
		yLonger = 1;
	}
	if (longLen == 0)
		decInc = 0;
	else
		decInc = (shortLen << 16) / longLen;

	if (yLonger) {
		if (longLen>0) {
			longLen += y;
			for (j=0x8000+(x<<16);y<=longLen;++y) {
				put_pixel(base ,j >> 16, y, rgb);
				j += decInc;
			}
			return;
		}
		longLen += y;
		for (j=0x8000+(x<<16);y>=longLen;--y) {
			put_pixel(base, j >> 16, y, rgb);
			j -= decInc;
		}
		return;
	}

	if (longLen > 0) {
		longLen += x;
		for (j=0x8000+(y<<16);x<=longLen;++x) {
			put_pixel(base, x, j >> 16, rgb);
			j += decInc;
		}
		return;
	}
	longLen += x;
	for (j=0x8000+(y<<16);x>=longLen;--x) {
		put_pixel(base, x, j >> 16, rgb);
		j -= decInc;
	}
}

void clear(alt_u16* base) {
	long i;
	for (i=0; i<(XRES*YRES); i++) {
		IOWR_16DIRECT(base, i*2, 0);
	}
	ch_xpos = 0;
	ch_ypos = 0;
}

void plot_char(alt_u16* base, int ch, int x, int y, int rgb) {
	int xx, yy, rr, m;

	for (yy=0; yy<8; yy++) {
		m = 1;
		for (xx=0; xx<8; xx++) {
			rr = 0x0;
			if ((font[ch][yy] & m) > 0)
				rr = rgb;
			m = m << 1;
			put_pixel(base, xx + x, yy + y, rr);
		}
	}
}

void set_char(alt_u16* base, int ch, int x, int y, int rgb) {	// 80x60
	int xx, yy;
	xx = x;
	yy = y;
	if (x > ((XRES / 8) - 1))
		xx = (XRES / 8) - 1;
	if (y > ((YRES / 8) - 1))
		yy = (YRES / 8) - 1;
	plot_char(base, ch, xx*8, yy*8, rgb);
}

void print_pos(int x, int y) {
	int xx, yy;
	xx = x;
	yy = y;
	if (x > ((XRES / 8) - 1))
		xx = (XRES / 8) - 1;
	if (y > ((YRES / 8) - 1))
		yy = (YRES / 8) - 1;
	ch_xpos = xx;
	ch_ypos = yy;
}

void scroll_up(alt_u16* base) {
	#ifndef DMA_HW
		int x, y, p;
		for (y=8; y<YRES; y++) {
			for (x=0; x<XRES; x++) {
				p = get_pixel(base, x, y);
				put_pixel(base, x, y-8, p);
			}
		}
	#else
	  IOWR(DMA_BASE, 1, 1); // reset
	  IOWR(DMA_BASE, 2, (alt_u32)base + ((XRES * 8) * 2));
	  IOWR(DMA_BASE, 3, (alt_u32)base);
	  IOWR(DMA_BASE, 4, (YRES - 8) * XRES);
	  IOWR(DMA_BASE, 0, 1); // go
	  while ((IORD(DMA_BASE, 0) & 0x2) != 0x0); // wait busy
	#endif
}

void print_char(alt_u16* base, int ch, int rgb) {
	set_char(base, ch, ch_xpos, ch_ypos, rgb);
	if (ch_xpos >= (XRES / 8) - 1) {
		ch_xpos = 0;
		if (ch_ypos >= ((YRES / 8) - 1)) {
			scroll_up(base);
		}
		else
			ch_ypos++;
	}
	else
		ch_xpos++;
}

void print_string(alt_u16* base, char *ch, int rgb) {
	int i;

	i = 0;
	while (*(ch+i) != 0) {
		print_char(base, *(ch + i), rgb);
		i++;
	}
}

void print_dec(alt_u16* base, alt_64 x, int rgb) {
	alt_u64 t;
	int i, j;
	char r[20];

	i = 0;
	j = 0;
	if (x == 0)
		print_char(base, '0', rgb);
	else
		if (x < 0) {
			print_char(base, '-', rgb);
			t = -x;
		}
		else {
			t = x;
			while (t > 0) {
				j++;
				r[i++] = 0x30 + (t % 10);
				t = t / 10;
				if ((j % 3) == 0)
					r[i++] = ',';
			}
			if (r[i-1] == ',')
				i=i-1;
			for (j=i-1; j>=0; j--)
				print_char(base, (char)r[j], rgb);
		}
}

void crlf(alt_u16* base) {
	ch_xpos = 0;
	if (ch_ypos >= ((YRES / 8) - 1)) {
		scroll_up(base);
	}
	else
		ch_ypos++;
}
#endif
