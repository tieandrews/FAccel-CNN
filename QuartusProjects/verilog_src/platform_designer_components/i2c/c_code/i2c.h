#ifndef I2C_H
#define I2C_H

#include <io.h>

void i2c_busy_wait(int base_addr) {
	while ((IORD(base_addr, 0) & 0x8) != 0);
}

void i2c_start_bit(int base_addr) {
	i2c_busy_wait(base_addr);
	IOWR(base_addr, 0, 0x4);
	IOWR(base_addr, 1, 0x0);
}

void i2c_stop_bit(int base_addr) {
	i2c_busy_wait(base_addr);
	IOWR(base_addr, 0, 0x2);
	IOWR(base_addr, 1, 0x0);
}

void i2c_write_bit(int base_addr, int bit) {
	i2c_busy_wait(base_addr);
	if (bit == 0)
		IOWR(base_addr, 0, 0);
	else
		IOWR(base_addr, 0, 1);
	IOWR(base_addr, 1, 0x0);
}

int i2c_read_bit(int base_addr) {
	i2c_busy_wait(base_addr);
	IORD(base_addr, 1);
	i2c_busy_wait(base_addr);
	return (IORD(base_addr, 0) & 0x1);
}

void i2c_nack(int base_addr) {
	i2c_write_bit(base_addr, 0x1);
}

int i2c_ack(int base_addr) {
	return i2c_read_bit(base_addr);
}

// terminate all transactions
void i2c_reset(int base_address) {
	int i;
	for (i=0; i<9; i++) {
		i2c_read_bit(base_address);
	}
	i2c_stop_bit(base_address);
}

// Write a byte to I2C bus. Return 0 if ack by the slave.
void i2c_write_word(int base_addr, int word, int bits) {
  int bit, mask;

  if (bits > 0) {
	  mask = 0x1 << (bits - 1);
	  for (bit = 0; bit<bits; bit++) {
		i2c_write_bit(base_addr, word & mask);
		word <<= 1;
	  }
  }
}

// Read a byte from I2C bus
int i2c_read_word(int base_addr, int bits) {
  int byte;
  int bit;

  byte = 0;
  if (bits > 0) {
	  for (bit = 0; bit<bits; bit++) {
		byte = (byte << 1) | i2c_read_bit(base_addr);
	  }
  }
  return byte;
}

#endif

