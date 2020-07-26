#include "sys/alt_stdio.h"
#include "system.h"
#include <io.h>
#include <unistd.h>

int main()
{ 
  alt_putstr("Hello from Nios II!\n");

  /* Event loop never exits. */
  while (1) {
	  usleep(200000);
	  alt_printf("x");
  }

  return 0;
}
