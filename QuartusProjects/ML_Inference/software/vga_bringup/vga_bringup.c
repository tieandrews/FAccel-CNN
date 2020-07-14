#include <stdio.h>
#include <io.h>
#include <stdlib.h>
#include <unistd.h>
#include "chars.h"
#include "system.h"
#include "coffee.h"

#define XRES 640
#define YRES 480
//#define BPP 2 // bytes per pixel
#define DMA_HW // yes this exists
//#define CHAR_BLIT_HW

alt_u16 *frame1_base, *frame2_base;

#include "vga_helper.h"


int get_rand(int x) {
	return (x * (rand() & 0xffff)) >> 16;
}

int main()
{
  int x, y;
  alt_u16* frame_base;
  printf("Hello from Nios II!\n");

  frame1_base = (alt_u16 *)malloc((XRES * YRES * 2) + 0x4);

  frame_base = frame1_base;
  if (((alt_u32)frame_base & 0x1) == 0x1)
    frame_base++;

  bringup_vga(frame_base);
  cursor_on(frame_base);
  clear(frame_base);
  print_string(frame_base, "VGA Bring-up Code", _WHITE);
  crlf(frame_base);

  x = 0;
  for (x=0; x<100; x++) {
 	  usleep(100);
 	  print_dec(frame_base, x, rand() & 0xffff);
 	  print_string(frame_base, " ", _RED);
 	  plot_line(frame_base, get_rand(XRES), get_rand(YRES), get_rand(XRES), get_rand(YRES), rand() & 0xffff);
   }

  for (y=0; y<63; y++)
	  for (x=0; x<63; x++)
		  put_pixel(frame_base, 100+x, 100+y, image64by64[x+(y*64)]);

  free(frame1_base);

  while (1) ;

  return 0;
}
