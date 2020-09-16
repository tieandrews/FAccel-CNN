#include "sys/alt_stdio.h"
#include "system.h"
#include <io.h>
#include <unistd.h>

int main()
{
  alt_u32 x;

  alt_putstr("Hello from Nios II!\n");

  /* Event loop never exits. */

  x = 0;
  while (1) {
	  usleep(200000);
	  IOWR(LED_BASE, 0, x & 0xff);
	  x = x + 1;
  }

  return 0;
}
