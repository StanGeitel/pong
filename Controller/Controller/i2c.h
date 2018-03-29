#ifndef I2C_H_
#define I2C_H_
#include <stdint.h>

#define SCL_FREQ	400			//kHz
#define BIT_TIME	2.5			//us
#define DEV_ADD		0b1101000
#define USICR_MASK	((0<<USISIE)|(0<<USISIE)|(1<<USIWM1)|(0<<USIWM0)|(1<<USICS1)|(0<<USICS0)|(1<<USICLK)|(0<<USITC))

#endif

void i2c_init(void);
void i2c_send_start(void);
void i2c_send_stop(void);
void i2c_send_ack(void);
void i2c_send_nack(void);
uint8_t i2c_get_ack(void);
void i2c_send_data(uint8_t);
uint8_t i2c_get_data(void);

void usi_init(void);
void usi_transfer(void);
