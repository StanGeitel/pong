#ifndef I2C_H_
#define I2C_H_
#include <stdint.h>

#define _PORT	0xB		//PORT B
#define _SCL	7		//PinB7 for SCL 
#define _SDA	5		//PinB5 for SDA
#define _INT	2		//PinD2 for interrupt

#define PIN(_PORT) _SFR_IO8(0x019-((_PORT-10)*3))
#define DDR(_PORT) _SFR_IO8(0x01A-((_PORT-10)*3))
#define PORT(_PORT) _SFR_IO8(0x01B-((_PORT-10)*3))

#define SCL_FREQ	400		//kHz
#define BIT_TIME	0.625	//us

#endif

void i2c_init(void);
void i2c_send_start(void);
void i2c_send_stop(void);
void i2c_send_ack(void);
void i2c_send_nack(void);
uint8_t i2c_get_ack(void);
void i2c_send_data(uint8_t);
uint8_t i2c_get_data(void);
