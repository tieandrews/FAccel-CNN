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
#include <unistd.h>
#include <io.h>
#include "i2c.h"
#include "lcd_td036thea1.h"
#include "eeprom_24lc02.h"
#include "camera_mt9p001.h"
#include "accelerometer_adxl345.h"

#define I2C_CAMERA_ADDRESS 0x5d
#define I2C_ACCELEROMETER_ADDRESS 0x1d

void set_led(int base, int value) {
	IOWR(base, 0, (value & 0xff));
}

int main()
{
  int ack, word;

  alt_putstr("DE0 Nano Board Bringup\n");

  // initial conditions
  IOWR(CAMERA_RESET_N_BASE, 0, 1);
  usleep(100000);
  IOWR(CAMERA_RESET_N_BASE, 0, 0);
  usleep(100000);
  IOWR(CAMERA_RESET_N_BASE, 0, 1);

  wait(1);

  alt_putstr("init lcd\n");
  ack = lcd_td036thea1_init(LCD_SERIAL_BASE);
  if (ack == 0) alt_putstr("->lcd init error\n");

  alt_putstr("reset i2c busses\n");
  i2c_reset(I2C_DE0_NANO_BASE);
  i2c_reset(I2C_CAMERA_BASE);

  alt_putstr("read accelerometer id ");
  word = accelerometer_adxl345_read8(I2C_DE0_NANO_BASE, I2C_ACCELEROMETER_ADDRESS, 0x0);
  alt_printf("%x\n", word);
  alt_putstr("read camera id on GPIO_0 ");
  word = camera_mt9p001_read16(I2C_CAMERA_BASE, I2C_CAMERA_ADDRESS, 0x0);
  alt_printf("%x\n", word);
  alt_putstr("read lcd id on GPIO_1 ");
  word = lcd_td036thea1_read8(LCD_SERIAL_BASE, 0x1);
  alt_printf("%x\n", word);


  /* Event loop never exits. */
  while (1) {
	  set_led(LED_DE0_NANO_BASE, 0xaa);
	  usleep(200000);
	  set_led(LED_DE0_NANO_BASE, 0x55);
	  usleep(200000);
  }

  return 0;
}
