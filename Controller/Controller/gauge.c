#include <avr/io.h>
#include <avr/interrupt.h>

#include "gauge.h"
#include "i2c.h"
#include "gpio.h"

void gauge_init(void){
	i2c_init();
//	i2c_single_write(GAUGE_ADD, CHARGE_MSB, 0xFF);
//	i2c_single_write(GAUGE_ADD, CHARGE_LSB, 0xFF);
	i2c_burst_write(GAUGE_ADD, CHARGE_MSB, 0xFF, 0xFF);
	i2c_burst_write(GAUGE_ADD, LOW_TRE_MSB, 0x7C, 0x1C);
	i2c_single_write(GAUGE_ADD, GAUGE_CON, 0x04);

	MCUCR |= (1<<ISC10);				//The rising edge of INT1 generates an interrupt request
	MCUCR |= (1<<ISC11);
	GIMSK |= (1<<INT1);					//enable external interrupt 1 in general interrupt mask register
	SREG |= (1<<SREG_I);				//enable interrupts I in global status register
}

void gauge_read_charge(){
	uint16_t buffer;
	buffer = i2c_burst_read(GAUGE_ADD, CHARGE_MSB);
	
	// q(LSB) ? 42,5 uAh daardoor nemen registers C en D 48235,29 stappen af in totaal (van 100-0 %)
	// 17301 is 0% en 31771,5 is 30% en 65535 is 100%
	if (buffer > 31772){
		PORT(_PORT) &= ~(1<<L0);
	}
	else{
		PORT(_PORT) |= (1<<L0);
	}
}

ISR(INT1_vect){							//External interrupt1 service routine
	
}

