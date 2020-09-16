#ifndef EEPROM_24LC02_H
#define EEPROM_24LC02_H

int eeprom_24lc02_write8(int base_address, int i2c_address, int address, int byte) {
	int ack;
	i2c_start_bit(base_address);
	i2c_write_word(base_address, (i2c_address & 0x7f), 0x7);
	i2c_write_bit(base_address, 0x0); // write_n
	ack = i2c_ack(base_address);
	if (ack == 0) {
		i2c_write_word(base_address, (address & 0xff), 0x8);
		ack |= i2c_ack(base_address);
	}
	if (ack == 0) {
		i2c_write_word(base_address, (byte & 0xff), 0x8);
		ack |= i2c_ack(base_address);
	}
	i2c_stop_bit(base_address);
	return ack;
}

int eeprom_24lc02_wait_busy(int base_address, int i2c_address) {
	int ack, timeout;

	timeout = 0;
	ack = 1;
	while ((ack != 0) && (timeout < 1000)) {
		i2c_start_bit(base_address);
		i2c_write_word(base_address, (i2c_address & 0x7f), 0x7);
		i2c_write_bit(base_address, 0x0); // write_n
		ack = i2c_ack(base_address);
		i2c_stop_bit(base_address);
		timeout++;
	}
	if (timeout >= 999) timeout = -1;
	return timeout;
}

int eeprom_24lc02_read8(int base_address, int i2c_address, int address) {
	int ack, byte;
	byte = -1;
	i2c_start_bit(base_address);
	i2c_write_word(base_address, (i2c_address & 0x7f), 0x7);
	i2c_write_bit(base_address, 0x0); // write
	ack = i2c_ack(base_address);
	if (ack == 0) {
		i2c_write_word(base_address, (address & 0xff), 0x8);
		ack = i2c_ack(base_address);
	}
	if (ack == 0) {
		i2c_start_bit(base_address);
		i2c_write_word(base_address, (i2c_address & 0x7f), 0x7);
		i2c_write_bit(base_address, 0x1); // read
		ack = i2c_ack(base_address);
	}
	if (ack == 0) {
		byte = i2c_read_word(base_address, 0x8);
		i2c_nack(base_address); 	// nack
	}
	i2c_stop_bit(base_address);
	if (ack != 0)
			byte = -1;
	return byte;
}

#endif
