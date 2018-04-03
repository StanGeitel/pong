#ifndef I2C_H_
#define I2C_H_
#include <stdint.h>

#define _PORT	0xA		//A for accelerometer, D for gauge
#define _SCL	1		//1	for accelerometer, 4 for gauge
#define _SDA	0		//0 for accelerometer, 3 for gauge

#define PIN(_PORT) _SFR_IO8(0x019 - ((_PORT - 10) * 3))
#define DDR(_PORT) _SFR_IO8(0x01A - ((_PORT - 10) * 3))
#define PORT(_PORT) _SFR_IO8(0x01B - ((_PORT - 10) * 3))

#define SCL_FREQ	400				//kHz
#define BIT_TIME	0.625			//us
#define DEV_ADD		0b1101000		//accelerometer address
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
