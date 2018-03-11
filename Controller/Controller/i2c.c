#include <avr/io.h>
#include "i2c.h"

void i2c_init(){
	USICR |= (1 << USIWM1);		//select Two-wire mode
//	DDRB |= (1 << DDB7) | (1 << DDB5);		//enable output driver for SCL, SCL is high unless forced low by start detector or bit PORTB register. SDA corresponds with MSB of USIDR and PORTB bit.
//	PORTB |= (1 << DDB7) | (1 << DDB5);		//set both high in portB
	USICR &= ~(3 << USICS0);	//clear USICS1 and 0 to enable clocking with USICLK
	
}


void i2c_write_data(uint8_t byte){
	
	for(int i = 0; i < 8; i++){
		
	}
	USIDR = byte;
	
}
