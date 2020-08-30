#include "sys/alt_stdio.h"
#include "system.h"
#include <io.h>
#include <unistd.h>

int main()
{
    int x;
    alt_putstr("Convolution Bringup\n");

    /* Event loop never exits. */
    alt_putstr("Complete");
    x = 0;
    while (1) {
    	IOWR(LED_BASE, 0, x++ & 0xff);
    	usleep(200000);
    }
    return 0;
}
