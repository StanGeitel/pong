#ifndef ACC_H_
#define ACC_H_
#include <stdint.h>

#define ACC_ADD		0b1101000		//accelerometer address

#endif

void acc_send_reg_add(uint8_t);
void acc_single_write(uint8_t, uint8_t);
uint8_t acc_single_read(uint8_t);
 void init_external_interrupt0(void);
