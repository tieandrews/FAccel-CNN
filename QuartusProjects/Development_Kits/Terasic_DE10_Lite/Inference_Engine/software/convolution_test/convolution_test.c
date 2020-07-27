#include "sys/alt_stdio.h"
#include "system.h"
#include <io.h>
#include <unistd.h>

alt_u16 kernel[9] = {0x30f8, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x3f80};

void convolution (alt_u32 source, alt_u32 dest, alt_u32 words, alt_u16* kernel, alt_u8 xres_sel, alt_u8 pad) {
	IOWR(CONVOLUTION_0_BASE, 1, ((xres_sel & 0x7) << 3) | (pad & 0x7));
	IOWR(CONVOLUTION_0_BASE, 2, source);
	IOWR(CONVOLUTION_0_BASE, 3, words);
	IOWR(CONVOLUTION_0_BASE, 4, dest);
	IOWR(CONVOLUTION_0_BASE, 5, kernel);
	IOWR(CONVOLUTION_0_BASE, 0, 1);	// go!
}

void clear_ram (alt_u32 addr, alt_u32 words, alt_u16 data) {
	alt_u32 i;
	for (i=0; i<words; i++) {
		IOWR_16DIRECT(addr, i, data++);
	}
}

int main()
{ 
  alt_putstr("Hello from Nios II!\n");

  clear_ram(SDRAM_BASE, 0x20, 0x11);
  clear_ram(SDRAM_BASE, 0x2000, 0x22);

  convolution (SDRAM_BASE, SDRAM_BASE + 0x2000, 64*64, kernel, 2, 1);

  /* Event loop never exits. */
  while (1) {
	  IOWR_32DIRECT(LED_BASE, 0, 0);
	  usleep(250000);
	  IOWR_32DIRECT(LED_BASE, 0, 1);
	  usleep(250000);
  }

  return 0;
}
