/* 
 *    - Use ALT versions of stdio routines:
 *
 *           Function                  Description
 *        ===============  =====================================
 *        alt_printf       Only supports %s, %x, and %c ( < 1 Kbyte)
 *        alt_putstr       Smaller overhead than puts with direct drivers
 *                         Note this function doesn't add a newline.
 *        alt_putchar      Smaller overhead than putchar with direct drivers
 *        alt_getchar      Smaller overhead than getchar with direct drivers
 *
 */

#include "sys/alt_stdio.h"
#include "system.h"
#include <io.h>
#include <stdlib.h>
#include "chars.h"
#include <unistd.h>

#define XRES 640
#define YRES 480
#define BPP 2 // bytes per pixel
#define DMA_HW // yes this exists

alt_u16 *frame1_base, *frame2_base;

#include "vga_helper.h"


int get_rand(int x) {
	return (x * (rand() & 0xffff)) >> 16;
}

int main()
{
  int x;
  alt_u16* frame_base;
  alt_putstr("Hello from Nios II!\n");

  frame1_base = (alt_u16 *)SDRAM_BASE; //(alt_u16 *)malloc((XRES * YRES * 2) + 0x100);
  frame1_base += 0x80;

  frame_base = frame1_base;

  bringup_vga(frame_base);
  cursor_on(frame_base);
  clear(frame_base);
  print_string(frame_base, "VGA Bring-up Code (small)", _WHITE);
  crlf(frame_base);

  x = 0;
  while (1) {
	  usleep(100);
	  print_dec(frame_base, x++, rand() & 0xffff);
	  print_string(frame_base, " ", _RED);
	  plot_line(frame_base, get_rand(XRES), get_rand(YRES), get_rand(XRES), get_rand(YRES), rand() & 0xffff);
  }

  return 0;
}
