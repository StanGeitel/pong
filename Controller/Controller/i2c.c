#include <avr/io.h>
#include "i2c.h"

void i2c_init(){
	PORTB = (1 << PINB5) | (1 << PINB7);	//set HIGH with pullup.
	DDRB = (1 << PINB5) | (1 << PINB7);		//enable output driver for SCL and SDA. SCL is high unless forced low by start detector or bit PORTB register. SDA corresponds with MSB of USIDR and PORTB bit.
	
	USIDR = 0xFF;
	USICR = (0 << USISIE) | (0 << USISIE) |		//disable interrupts
			(1 << USIWM1) | (0 << USIWM0) |		//set two-wire mode
			(1 << USICS1) | (0 USICS0) | (1 << USICLK) |		//software clock strobe as counter clock source
			(0 << USITC);
	USISR = (1 << USISIF) | (1 << USIOIF) | ( 1<< USIPF ) | (1 << USIDC) |      // Clear flags,
			(0x0<<USICNT0);		//reset counter value
			
//	USICR |= (1 << USITC);
}


void i2c_write_data(uint8_t byte){
	
	for(int i = 0; i < 8; i++){
		
	}
	USIDR = byte;
	
}
