#ifndef GAUGE_H_
#define GAUGE_H_
#include <stdint.h>

#define GAUGE_ADD		0b1100100		//gauge address
#define CHARGE_MSB		0x02			//accumulated charge MSB
#define CHARGE_LSB		0x03			//accumulated charge LSB

#endif

void gauge_init(void);
void gauge_send_reg_add(uint8_t);
//uint8_t gauge_single_read(uint8_t);
void gauge_single_write(uint8_t, uint8_t);
void gauge_batterylevel(void);
void ext_int1_init(void);