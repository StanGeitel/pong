#ifndef GAUGE_H_
#define GAUGE_H_
#include <stdint.h>

#define GAUGE_ADD		0b1100100		//gauge address

#endif

void gauge_unit(void);
void gauge_send_reg_add(uint8_t);
uint8_t gauge_single_read(uint8_t);
void gauge_single_write(uint8_t, uint8_t);
uint8_t gauge_double_read(uint8_t);