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

void bringup_vga(alt_u16* base) {
  IOWR(DMA_BASE, 0, 0); // reset DMA
  while ((IORD(DMA_BASE, 0) & 0x2) != 0);
  IOWR(FRAME_READER_BASE, 0, 0);
  while ((IORD(FRAME_READER_BASE, 0) & 0x2) != 0);
  IOWR(VGA_OUT_BASE, 0, 0);
  while ((IORD(VGA_OUT_BASE, 0) & 0x2) != 0);

  IOWR(DMA_BASE, 1, 1);
  IOWR(FRAME_READER_BASE, 1, 1);
  IOWR(VGA_OUT_BASE, 1, 1);

  IOWR(FRAME_READER_BASE, 2, (alt_u32)base);
  IOWR(VGA_OUT_BASE, 0, 1);
  IOWR(FRAME_READER_BASE, 0, 1);
}

int main()
{
  int x;
  alt_u16* frame_base;
  alt_putstr("Hello from Nios II!\n");

  frame1_base = (alt_u16 *)malloc((XRES * YRES * 2) + 0x100);
  frame1_base += 0x80;

  frame_base = frame1_base;

  bringup_vga(frame_base);
  clear(frame_base);
  print_string(frame_base, "This is a test ", _WHITE);

  while (1) {
  }

  return 0;
}
