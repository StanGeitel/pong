#ifndef I2C_H_
#define I2C_H_
#include <stdint.h>

#define BIT_TIME	0.625	//us

#endif

void i2c_single_write(uint8_t, uint8_t, uint8_t);
void i2c_burst_write(uint8_t, uint8_t, uint8_t, uint8_t);
uint8_t i2c_single_read(uint8_t, uint8_t);
uint16_t i2c_burst_read(uint8_t, uint8_t);
void i2c_send_reg_add(uint8_t, uint8_t);
void i2c_init(void);
void i2c_send_start(void);
void i2c_send_stop(void);
void i2c_send_ack(void);
void i2c_send_nack(void);
uint8_t i2c_get_ack(void);
void i2c_send_data(uint8_t);
uint8_t i2c_get_data(void);
