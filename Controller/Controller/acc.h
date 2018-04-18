#ifndef ACC_H_
#define ACC_H_
#include <stdint.h>

#define ACC_ADD		0b1101000		//accelerometer address
#define ACC_SAMP	1000			//Hz

#define ACC_CON		0x1C			//register addresses
#define SMPRT_DIV	0x19
#define FIFO_EN		0x23
#define INT_CON		0x37
#define INT_EN		0x38
#define PWR_MAN		0x6B
#define X_MSB		0x3B
#define X_LSB		0x3C
#define Y_MSB		0x3D
#define Y_LSB		0x3E

#define LSB_SENS	16384			//lsb sensitivity for +/-2g, +1g = +16384 sensor value 

#define X_COM		0b111000
#define Y_COM		0b111001

#endif

void acc_init(void);
void acc_calibrate(void);
void test(void);
