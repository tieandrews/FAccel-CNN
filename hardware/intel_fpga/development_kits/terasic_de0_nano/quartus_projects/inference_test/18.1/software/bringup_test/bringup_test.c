#include "sys/alt_stdio.h"
//#include <stdio.h>
#include <io.h>
#include <unistd.h>
#include <math.h>
#include "system.h"
//#include "printf.h"
#include "fr.h"

//////////////////////////////////////////////////////////////////////////////
union IntFloat {  alt_u32 i;  float f;  };
typedef alt_u16 bfloat16;

//////////////////////////////////////////////////////////////////////////////
void _putchar(char character)
{
	alt_putchar((int)character);	// printf_ character output
}

//////////////////////////////////////////////////////////////////////////////
float bf2f(bfloat16 x) { // bfloat to float
     union IntFloat f;
     f.i = ((alt_u32)x << 16);
     return f.f;
}

//////////////////////////////////////////////////////////////////////////////
bfloat16 f2bf(float x) { // float to bfloat
     union IntFloat f;
     f.f = x;
     return (bfloat16)(f.i >> 16);
}

//////////////////////////////////////////////////////////////////////////////
bfloat16 bf_mult(bfloat16 a, bfloat16 b) {
     return f2bf(bf2f(a) * bf2f(b));
}

//////////////////////////////////////////////////////////////////////////////
bfloat16 bf_add(bfloat16 a, bfloat16 b) {
     return f2bf(bf2f(a) + bf2f(b));
}

//////////////////////////////////////////////////////////////////////////////
bfloat16 bf_neg(bfloat16 a) {
     return f2bf(-bf2f(a));
}

//////////////////////////////////////////////////////////////////////////////
bfloat16 bf_gt(bfloat16 a, bfloat16 b) {
     return bf2f(a) > bf2f(b);
}

//////////////////////////////////////////////////////////////////////////////
bfloat16 bf_lt(bfloat16 a, bfloat16 b) {
     return bf2f(a) < bf2f(b);
}

//////////////////////////////////////////////////////////////////////////////
void put_pixel(alt_u16* base, alt_u16 res, alt_u16 x, alt_u16 y, alt_u16 data) {
	IOWR_16DIRECT(base, (x + (y * res)) << 1, data);
}

//////////////////////////////////////////////////////////////////////////////
alt_u16 get_pixel(alt_u16* base, alt_u16 res, alt_u16 x, alt_u16 y) {
	return IORD_16DIRECT(base, (x + (y * res)) << 1);
}

//////////////////////////////////////////////////////////////////////////////
void show_featuremap(alt_u16* base, alt_u16 res) {
	alt_u32 x, y;
	for (y=0; y<res; y++) {
		for (x=0; x<res; x++) {
			alt_printf("%x ", get_pixel(base, res, x, y));
		}
		alt_printf("\n");
	}
}

//////////////////////////////////////////////////////////////////////////////
void relu (alt_u16* featuremap, alt_u16 res) {
	alt_u32 x, i;

	x = res * res;
	for (i=0; i<x; i++) {
		if (IORD_16DIRECT(featuremap, (i << 1)) & 0x8000) { // test sign bit
			IOWR_16DIRECT(featuremap, (i << 1), 0x0);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////
void padding (alt_u16* src_map, alt_u16* dst_map, alt_u16 res, alt_u16 pad) {
	alt_u32 i, j, pixel;
	alt_u32 src, dst;

	dst = 0;
	src = 0;
	for (j=0; j<pad; j++) {	// pad TOP pixels
		for (i=0; i<(res + (pad << 1)); i++) {
			IOWR_16DIRECT(dst_map, (dst), 0);
			dst += 2;
		}
	}
	for (j=0; j<res; j++) {
		for (i=0; i<pad; i++) {
			IOWR_16DIRECT(dst_map, (dst), 0); // pad LHS
			dst += 2;
		}
		for (i=0; i<res; i++) {
			pixel = IORD_16DIRECT(src_map, src);
			src += 2;
			IOWR_16DIRECT(dst_map, (dst), pixel);
			dst += 2;
		}
		for (i=0; i<pad; i++) {
			IOWR_16DIRECT(dst_map, (dst), 0); // pad RHS
			dst += 2;
		}
	}
	for (j=0; j<pad; j++) {	// pad BOTTOM pixels
		for (i=0; i<(res + (pad << 1)); i++) {
			IOWR_16DIRECT(dst_map, (dst), 0);
			dst += 2;
		}
	}
}

//////////////////////////////////////////////////////////////////////////////
void convolution(alt_u16* src, alt_u16 clr, alt_u16* dst, alt_u16* knl,
		alt_u16 k, alt_u16 res, alt_u16 pad, alt_u16 stride) {
	alt_16 x, y, ks;
	alt_32 kx, ky, dst_ptr, offset_s, offset_d;
	bfloat16 sum, src_pix, k_pix;

	ks = (k >> 1); // k is odd 3,5,7 ... ks generally equal to pad
	dst_ptr = 0;
	for (y=pad; y<(res + pad); y=y+stride) {
		for (x=pad; x<(res + pad); x=x+stride) {
			sum = f2bf(0.0); // 0x0
			for (ky=-ks; ky<ks; ky++) {
				offset_s = (res * (y + ky)) + x;
				offset_d = (k * ky);
				for (kx=-ks; kx<ks; kx++) {
					src_pix = IORD_16DIRECT(src, (kx + offset_s) << 1);
					k_pix = IORD_16DIRECT(knl, (kx + offset_d) << 1);
					sum = bf_add(sum, bf_mult(src_pix, k_pix)); // sum of products
				}
			}
			if (clr == 0)
				sum += IORD_16DIRECT(dst, dst_ptr);
			IOWR_16DIRECT(dst, dst_ptr, sum);
			dst_ptr += 2;
		}
	}
}

//////////////////////////////////////////////////////////////////////////////
void maxpool(alt_u16* src, alt_u16* dst, alt_u16 k, alt_u16 res, alt_u16 pad, alt_u16 stride) {
	alt_16 x, y, kx, ky;
	alt_u32 dst_ptr;
	float src_pix;
	bfloat16 max;

	dst_ptr = 0;
	for (y=pad; y<(res + pad); y=y+stride) {
		for (x=pad; x<(res + pad); x=x+stride) {
			max = f2bf(-10000.0); // negative enough?
			for (ky=0; ky<k; ky++) {
				for (kx=0; kx<k; kx++) {
					src_pix = bf2f(IORD_16DIRECT(src, ((x + kx) + (res * (y + ky))) << 1));
					if (src_pix > max)
						max = f2bf(src_pix);
				}
			}
			IOWR_16DIRECT(dst, dst_ptr, max);
			dst_ptr += 2;
		}
	}
}

//////////////////////////////////////////////////////////////////////////////
bfloat16 global_average_pooling(alt_u16* src, alt_u16 res) {
	alt_u32 x, src_ptr;
	bfloat16 sum;

	sum = f2bf(0.0);
	src_ptr = 0;
	for (x=0; x<(res*res); x++) {
		sum = bf_add(sum, IORD_16DIRECT(src, src_ptr));
		src_ptr += 2;
	}
	return f2bf(bf2f(sum) / (float)(res * res));
}

//////////////////////////////////////////////////////////////////////////////
void softmax(alt_u16* src, alt_u16 input_len) {
	alt_u16 i;
	float m, sum, offset;

	sum = 0.0;
	m = -INFINITY;
	for (i = 0; i < input_len; i++)
		if (bf2f(src[i]) > m)
			m = bf2f(src[i]);
	for (i = 0; i < input_len; i++)
		sum += expf(bf2f(src[i]) - m);
	offset = m + logf(sum);
	for (alt_u16 i = 0; i < input_len; i++)
		src[i] = f2bf(expf(src[i] - offset));
}

//////////////////////////////////////////////////////////////////////////////
// resize a 565 bitmap
void scale(alt_u16* src, alt_u16* dst, alt_u16 width, alt_u16 height, alt_u16 new_width, alt_u16 new_height) {
		alt_u16 cx, cy, pixel, src_ptr;
		alt_32 nearest;
		float scale_width, scale_height;

        scale_width =  (float)new_width / (float)width;
        scale_height = (float)new_height / (float)height;

        src_ptr = 0;
        for(cy = 0; cy < new_height; cy++) {
            for(cx = 0; cx < new_width; cx++) {
                nearest =  (int)(((float)(cy * width) / scale_height) + ((float)cx / scale_width));
                pixel = IORD_16DIRECT(src, nearest << 1);
                IOWR_16DIRECT(dst, src_ptr, pixel);
                src_ptr += 2;
            }
        }
}

//////////////////////////////////////////////////////////////////////////////
void rgb565_to_feature(alt_u16* src, alt_u16* dst_r, alt_u16* dst_g, alt_u16* dst_b, alt_u16 res) {
	alt_u16 pixel;
	alt_u32 i, ptr;

	ptr = 0;
	for (i=0; i<(res*res); i++) {
		pixel = IORD_16DIRECT(src, ptr);
		IOWR_16DIRECT(dst_r, ptr, f2bf((float)((pixel & 0xf800) >> 8) / 255.0));
		IOWR_16DIRECT(dst_g, ptr, f2bf((float)((pixel & 0x7e0) >> 3) / 255.0));
		IOWR_16DIRECT(dst_b, ptr, f2bf((float)((pixel & 0x1f) << 3) / 255.0));
		ptr += 2;
	}
}

//////////////////////////////////////////////////////////////////////////////
void grey_to_feature(alt_u16* src, alt_u16* dst, alt_u16 res) {
	alt_u16 pixel;
	alt_u32 i, ptr;

	ptr = 0;
	for (i=0; i<(res*res); i++) {
		pixel = IORD_16DIRECT(src, ptr);
		IOWR_16DIRECT(dst, ptr, f2bf(((float)pixel) / 255.0));
		ptr += 2;
	}
}

//////////////////////////////////////////////////////////////////////////////
alt_u16 rgb_to_grey(alt_u16 rgb565) {
	alt_u16 grey;

	grey = (alt_u16)((float)((rgb565 & 0xf800) >> 8) * 0.299);
	grey += (alt_u16)((float)((rgb565 & 0x07e0) >> 3) * 0.587);
	grey += (alt_u16)((float)((rgb565 & 0x001f) << 3) * 0.114);
	return grey;
}

//////////////////////////////////////////////////////////////////////////////
void rgb565_to_text(alt_u16* src, alt_u16 res, alt_u16 step, alt_u16 negative) {

	alt_u16 x, y, xx, yy;
	alt_u32 line, src_ptr, sum;
	alt_u8 char_grey[92] = {32,96,45,46,39,95,58,44,34,61,94,59,60,43,33,42,63,
			47,99,76,92,122,114,115,55,84,105,118,74,116,67,123,51,70,41,73,108,
			40,120,90,102,89,53,83,50,101,97,106,111,49,52,91,110,117,121,69,93,
			80,54,86,57,107,88,112,75,119,71,104,113,65,85,98,79,100,56,35,72,
			82,68,66,48,36,109,103,77,87,38,81,37,78,64};

	for (y=0; y<res; y+=step) {
		line = (y * res);
		for (x=0; x<res; x+=step) {
			sum = 0;
			src_ptr = (x + line) << 1;
			for (yy=0; yy<step; yy++)
				for (xx=0; xx<step; xx++)
					sum += rgb_to_grey(IORD_16DIRECT(src, src_ptr + ((xx + (yy * res)) << 1)));
			sum = (sum / (step * step));
			sum = (sum * 92) / 255;		// scale grey count
			alt_printf("%c", char_grey[sum]);
		}
		alt_printf("\n");
	}
}
//////////////////////////////////////////////////////////////////////////////
void grey_to_text(alt_u16* src, alt_u16 res, alt_u16 step, alt_u16 negative) {

	alt_u16 x, y, xx, yy;
	alt_u32 line, src_ptr, sum;
	alt_u8 char_grey[92] = {32,96,45,46,39,95,58,44,34,61,94,59,60,43,33,42,63,
			47,99,76,92,122,114,115,55,84,105,118,74,116,67,123,51,70,41,73,108,
			40,120,90,102,89,53,83,50,101,97,106,111,49,52,91,110,117,121,69,93,
			80,54,86,57,107,88,112,75,119,71,104,113,65,85,98,79,100,56,35,72,
			82,68,66,48,36,109,103,77,87,38,81,37,78,64};

	for (y=0; y<res; y+=step) {
		line = (y * res);
		for (x=0; x<res; x+=step) {
			sum = 0;
			src_ptr = (x + line) << 1;
			for (yy=0; yy<step; yy++)
				for (xx=0; xx<step; xx++)
					sum += IORD_16DIRECT(src, src_ptr + ((xx + (yy * res)) << 1));
			sum = (sum / (step * step));
			sum = (sum * 92) / 255;		// scale grey count
			alt_printf("%c", char_grey[sum]);
		}
		alt_printf("\n");
	}
}

//////////////////////////////////////////////////////////////////////////////
int main()
{
	bfloat16*

	rgb565_to_feature(image64by64, );

	return 0;
}
