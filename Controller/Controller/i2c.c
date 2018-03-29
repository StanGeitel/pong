#define F_CPU				1000000UL		//1MHz
#include <avr/io.h>
#include <util/delay.h>

#include "i2c.h"

void i2c_init(){
	PORTB = (1 << PINB5) | (1 << PINB7);	//set HIGH with pull up.
	DDRB = (1 << PINB5) | (1 << PINB7);		//enable output driver for SDA and SCL.
	
}

void i2c_send_start(){
	PORTB &= ~(1<<PINB5);			//force SDA low
	while(PORTB & (1<<PINB5));		//wait for SDA low
	_delay_us(BIT_TIME);
	PORTB &= ~(1<<PINB7);			//force SCL low
}

void i2c_send_stop(){
	PORTB &= ~(1<<PINB5);			//force SDA low
	while(PORTB & (1<<PINB5));		//wait for SDA low
	PORTB |= (1<<PINB7);			//release SCL
	while(!(PORTB & (1<<PINB7)));	//wait for SCL high
	PORTB |= (1<<PINB5);			//release SDA
}

void i2c_send_ack(){
	PORTB &= ~(1<<PINB5);			//force SDA low
	while(PORTB & (1<<PINB5));		//wait for SDA to go low
	PORTB |= (1<<PINB7);			//release SCL
	while(!(PORTB & (1<<PINB7)));	//wait for SCL to go high
	PORTB &= ~(1<<PINB7);			//force SCL low
	PORTB |= (1<<PINB5);			//release SDA
}

void i2c_send_nack(){
	PORTB |= (1<<PINB5);			//release SDA
	while(!(PORTB & (1<<PINB5)));	//wait for SDA to go high
	PORTB |= (1<<PINB7);			//release SCL
	while(!(PORTB & (1<<PINB7)));	//wait for SCL to go high
	PORTB &= ~(1<<PINB7);			//force SCL low
}

uint8_t i2c_get_ack(){
	uint8_t ret;
	
	DDRB &= ~(1<<PINB5);					//set SDA as input
	PORTB &= ~(1<<PINB5);					//disable SDA pull up
	
	PORTB |= (1<<PINB7);					//release SCL
	while(!(PORTB & (1<<PINB7)));			//wait for SCL to go high
	
	if(PORTB & (1<<PINB5)){					//read if SDA is 1
		ret = 1;
	}else{
		ret = 0;
	}
	_delay_us(BIT_TIME);					//wait a bit
	PORTB &= ~(1<<PINB7);					//force SCL low
	
	PORTB |= (1<<PINB5);					//enable SDA pull up
	DDRB |= (1<<PINB5);						//set as SDA as output
	return(ret);
}

void i2c_send_data(uint8_t data){
	PORTB &= ~(1<<PINB7);					//pull SCL low
	for(int i = 0; i <= 7; i++){			//count bit 0 to 7 
		while(PORTB & (1<<PINB7));			//wait for SCL to go low
		
		if((data>>i) & 1){					//read if data bit on position i is 1
			PORTB |= (1<<PINB5);			//write SDA 1
		}else{
			PORTB &= ~(1<<PINB5);			//write SDA 0
		}
		
		PORTB |= (1<<PINB7);				//release SCL
		while(!(PORTB & (1<<PINB7)));		//wait for SCL to go high
		_delay_us(BIT_TIME);
		PORTB &= ~(1<<PINB7);				//force SCL low
		_delay_us(BIT_TIME);
	}
}


uint8_t i2c_get_data(){
	uint8_t buf;
	
	DDRB &= ~(1<<PINB5);					//set as input
	PORTB &= ~(1<<PINB5);					//disable pull up
	
	PORTB &= ~(1<<PINB7);					//pull SCL low
	for(int i = 0; i <= 7; i++){			//count bit 0 to 7
		while(PORTB & (1<<PINB7));			//wait for SCL to go low
		
		if(PORTB & (1<<PINB5)){				//read if SDA is 1
			buf |= (1<<i);					//write bit on position i 1
		}else{
			buf &= ~(1<<i);					//write bit on position i 0
		}
		
		PORTB |= (1<<PINB7);				//release SCL
		while(!(PORTB & (1<<PINB7)));		//wait for SCL to go high
		_delay_us(BIT_TIME);
		PORTB &= ~(1<<PINB7);				//force SCL low
		_delay_us(BIT_TIME);
	}
	
	return(buf);
}

/*
void usi_init(){
	PORTB = (1 << PINB5) | (1 << PINB7);	//set HIGH with pull up.
	DDRB = (1 << PINB5) | (1 << PINB7);		//enable output driver for SDA and SCL.
	//SDA corresponds with MSB of USIDR and PORTB bit. SCL is high unless forced low by start detector or bit PORTB register.

	USIDR = 0xFF;							//set data register high for start condition
	USICR = USICR_MASK;						//control register mask
	USISR = (1<<USISIF)|(1<<USIOIF)|(1<<USIPF)|(1<<USIDC)|(0x0<<USICNT0);	//reset flags and counter value
	
}

void usi_transfer(){				//generates 8 clock pulses
	USISR &= ~(0xF << USICNT0);				//reset counter
	do{
		USICR = USICR_MASK|(1<<USITC);		//toggle SCL to HIGH
		while(!(PORTB & (1<<PINB7)));		//wait until SCL is HIGH
		_delay_ms(1000);
		USICR = USICR_MASK|(1<<USITC);		//toggle SCL to LOW
		_delay_ms(1000);
	}while(!(USISR & (1 << USICNT3)));		//check if counter is 8
	_delay_us(BIT_TIME);
}
*/
