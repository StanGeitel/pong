#ifndef GAUGE_H_
#define GAUGE_H_
#include <stdint.h>

#define GAUGE_ADD		0b1100100		//gauge address
#define GAUGE_CON		0x01
#define CHARGE_MSB		0x02			//accumulated charge MSB
#define CHARGE_LSB		0x03			//accumulated charge LSB
#define HIGH_TRE_MSB	0x04
#define HIGH_TRE_LSB	0x05
#define LOW_TRE_MSB		0x06
#define LOW_TRE_LSB		0x07
#define ARA				0x0C			//Alert Response Address				

#endif

void gauge_init(void);
void i2c_send_arp_gauge(void);
