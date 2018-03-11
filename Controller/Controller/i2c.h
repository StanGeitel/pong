#ifndef I2C_H_
#define I2C_H_
#include <stdint.h>


void i2c_init();
uint8_t i2c_read_data();
void i2c_write_data(uint8_t);


#endif