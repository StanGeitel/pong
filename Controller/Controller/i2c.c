#include <avr/io.h>
#include "i2c.h"

void i2c_init(){
	USICR |= (1 << USIWM1);		//select Two-wire mode
	DDRB |= (1 << DDB7);		//enable output driver for SCL, SCL is high unless forced low by start detector or bit PORTB register.
	DDRB |= (1 << DDB5);		//enable output driver for SDA, SDA corresponds with MSB of USIDR
	USICR &= ~(3 << USICS0);	//clear USICS1 and 0 to enable clocking with USICLK

}

uint8_t i2c_read_data(){
	return(USIDR);
}

void i2c_write_data(uint8_t byte){
	
	USIDR = byte;
	
}

ISR(USI_START_vect){
	
}