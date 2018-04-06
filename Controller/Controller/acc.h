#ifndef ACC_H_
#define ACC_H_
#include <stdint.h>

#define ACC_ADD		0b1101000		//accelerometer address

#define ACC_CON		0x1C
#define INT_CON		0x37
#define INT_EN		0x38
#define X_MSB		0x3B
#define X_LSB		0x3C
#define Y_MSB		0x3D
#define Y_LSB		0x3E

#define X_COM		0b000
#define Y_COM		0b001

#endif

void acc_init(void);
void ext_int0_init(void);
void acc_single_write(uint8_t, uint8_t);
void acc_burst_write(uint8_t, uint8_t, uint8_t);
uint8_t acc_single_read(uint8_t);
uint16_t acc_burst_read(uint8_t);
void acc_send_reg_add(uint8_t);
void acc_calc_x_pos(void);
void acc_calc_y_pos(void);
void acc_calibrate(void);
