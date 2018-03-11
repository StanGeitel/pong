#ifndef I2C_H_
#define I2C_H_
#include <stdint.h>

#define SCL_FREQ 400	//kHz


void i2c_init();
void i2c_write_data(uint8_t);


#endif