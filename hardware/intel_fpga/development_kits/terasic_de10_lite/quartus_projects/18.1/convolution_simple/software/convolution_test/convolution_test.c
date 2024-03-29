#include "sys/alt_stdio.h"
#include "sys/alt_irq.h"
#include <io.h>
#include <unistd.h>
#include "system.h"
#include "printf.h"

#define KX 3
#define KY 3
#define XRES 8
#define YRES 8

union IntFloat {  alt_u32 i;  float f;  };
typedef alt_u16 bfloat16;

//////////////////////////////////////////////////////////////////////////////
// Setup and handle IRQ events
// #ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
static void handle_conv_irq(void* context)
{
	IOWR(CONVOLUTION_BASE, 0, IORD(CONVOLUTION_BASE, 0) | 0x8);	// clear irq
	alt_putchar(0x41);
}
static void init_conv_irq()
{
	IOWR(CONVOLUTION_BASE, 0, IORD(CONVOLUTION_BASE, 0) | 0x4);	// enable irq
	alt_ic_isr_register(CONVOLUTION_IRQ_INTERRUPT_CONTROLLER_ID, CONVOLUTION_IRQ, handle_conv_irq, 0, 0);
	alt_ic_irq_enable(CONVOLUTION_IRQ_INTERRUPT_CONTROLLER_ID, CONVOLUTION_IRQ);
}
//////////////////////////////////////////////////////////////////////////////

void _putchar(char character)
{
	alt_putchar(character);	// printf_ character output
}

float bf2f(bfloat16 x) { // bfloat_to_float
     union IntFloat f;
     f.i = ((alt_u32)x << 16);
     return f.f;
}

bfloat16 f2bf(float x) {
     union IntFloat f;
     f.f = x;
     return (bfloat16)(f.i >> 16);
}

bfloat16 bf_mult(bfloat16 a, bfloat16 b) {
     return f2bf(bf2f(a) * bf2f(b));
}

bfloat16 bf_add(bfloat16 a, bfloat16 b) {
     return f2bf(bf2f(a) + bf2f(b));
}

void put_pixel(alt_u16* base, alt_u32 xres, alt_u32 x, alt_u32 y, alt_u32 data) {
	IOWR_16DIRECT(base, (x + (y * xres)) * 2, (data & 0xffff));
}

alt_u16 get_pixel(alt_u16* base, alt_u32 xres, alt_u32 x, alt_u32 y) {
	return IORD_16DIRECT(base, (x + (y * xres)) * 2);
}

void show_featuremap(alt_u16* base, alt_u32 xres, alt_u32 yres) {
	alt_u32 x, y;
	for (y=0; y<yres; y++) {
		for (x=0; x<xres; x++) {
			printf_("%x ", get_pixel(base, xres, x, y));
		}
		printf_("\n");
	}
}

void convolution(alt_u32* base, alt_u32 xres, alt_u32 pad, bfloat16* kptr, bfloat16* src, bfloat16* dst) {
	while((IORD(base, 0) & 0x2) != 0);
	IOWR(base, 1, (alt_u32)xres);
	IOWR(base, 2, (alt_u32)pad);
	IOWR(base, 3, (alt_u32)kptr);
	IOWR(base, 4, (alt_u32)src);
	IOWR(base, 5, (alt_u32)dst);
	IOWR(base, 0, 1);
}

int main()
{
	alt_u32 x, y, k;
	bfloat16 kernel[KX][KY], src[XRES][YRES], dst[XRES][YRES];

	init_conv_irq();

	printf_("Convolution Test\n");

    for (y=0; y<KY; y++)
    	for (x=0; x<KX; x++)
    		put_pixel((alt_u16*)kernel, KX, x, y, f2bf(1.0));

    for (y=0; y<YRES; y++)
    	for (x=0; x<XRES; x++) {
    		src[x][y] = f2bf((float)x);
    		dst[x][y] = f2bf((float)(x+100));
    	}
	IOWR(CONVOLUTION_BASE, 1, 2);
	IOWR(CONVOLUTION_BASE, 2, 1);
	IOWR(CONVOLUTION_BASE, 3, (alt_u32)kernel);
	IOWR(CONVOLUTION_BASE, 4, (alt_u32)src);
	IOWR(CONVOLUTION_BASE, 5, (alt_u32)dst);
	IOWR(CONVOLUTION_BASE, 0, 5);

	while ((IORD(CONVOLUTION_BASE, 0) & 0x2) != 0);

	printf_("Complete\n");
    printf_("========================================\n");
	show_featuremap((alt_u16*)dst, XRES, YRES);

	k = 0;
    while (1) {
        usleep(200000);
        k++;
        if (k>=50) {
        	printf_("\n");
        	k = 0;
        }
		printf_("x");

    }

  return 0;
}
