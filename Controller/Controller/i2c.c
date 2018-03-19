#include <avr/io.h>

#include "i2c.h"

void init(){
	DDRB = (1 << PINB5) | (1 << PINB7);		//enable output driver for SDA and SCL.
	PORTB = (1 << PINB5) | (1 << PINB7);	//set HIGH with pull up.
}

void send_start(){
	PORTB &= ~(1<<PINB5);			//force SDA low
	while(!(PORTB & (1<<PINB5)));	//wait for SDA to go low
	PORTB &= ~(1<<PINB7);			//force SCL low

}
























































/*
void i2c_init(){
	PORTB = (1 << PINB5) | (1 << PINB7);	//set HIGH with pull up.
	DDRB = (1 << PINB5) | (1 << PINB7);		//enable output driver for SDA and SCL.
	//SDA corresponds with MSB of USIDR and PORTB bit. SCL is high unless forced low by start detector or bit PORTB register.
	
	USIDR = 0xFF;							//set data register high for start condition
	USICR = USICR_MASK;						//control register mask
	USISR = (1<<USISIF)|(1<<USIOIF)|(1<<USIPF)|(1<<USIDC)|(0x0<<USICNT0);	//reset flags and counter value
	
}

void i2c_send_start(){
	PORTB &= ~(1<<PINB5);			//force SDA low
	PORTB &= ~(1<<PINB7);			//force SCL low
	PORTB |= (1<<PINB5);			//release SDA
	PORTB |= (1<<PINB7);			//release SCL
}

void i2c_send_stop(){
	PORTB &= ~(1<<PINB5);			//force SDA low
	while(!(PORTB & (1<<PINB5)));
	PORTB |= (1<<PINB7);			//release SCL
	while(!(PORTB & (1<<PINB7)));	//wait for SCL to go high
	_delay_us(BIT_TIME/2);
	PORTB |= (1<<PINB5);			//release SDA
}

void i2c_send_ack(){
	PORTB &= ~(1<<PINB5);
	while(PORTB & (1<<PINB5));
	PORTB |= (1<<PINB7);
	while(!(PORTB & (1<<PINB7)));
	_delay_us(BIT_TIME);
	PORTB &= ~(1<<PINB7);
	PORTB |= (1<<PINB5);
}

void i2c_send_nack(){
	PORTB |= (1<<PINB5);
	while(!(PORTB & (1<<PINB5)));
	PORTB |= (1<<PINB7);
	while(!(PORTB & (1<<PINB7)));
	_delay_us(BIT_TIME);
	PORTB &= ~(1<<PINB7);
}

void i2c_transfer(){
	USISR &= ~(0xF << USICNT0);				//reset counter
	do{
		_delay_us(BIT_TIME/2);
		USICR = USICR_MASK|(1<<USITC);		//toggle SCL to HIGH
		while(!(PORTB & (1<<PINB7)));		//wait until SCL is HIGH
		_delay_us(BIT_TIME/2);
		USICR = USICR_MASK|(1<<USITC);		//toggle SCL to LOW
	}while(!(USISR & (1 << USICNT3)));		//check if counter is 8
}

uint8_t i2c_read(uint8_t reg_address){
	uint8_t ret;

	i2c_send_start();							//send start condition
	USIDR = (DEV_ADD<<1);						//device address with LSB zero is a write
	i2c_transfer();
	_delay_us(BIT_TIME/2)
	
	DDRB &= ~(1<<PINB5);
	if(!(PORTB & (1<<PINB5))){					//wait for ack
		DDRB |= (1<<PINB5);
		USIDR = reg_address;					//send register address
		i2c_transfer();
		_delay_us(BIT_TIME/2);
		DDRB &= ~(1<<PINB5);
		if(!(PORTB & (1<<PINB5))){				//wait for ack
			DDRB |= (1<<PINB5);
			i2c_send_start();				//send start condition
			USIDR = ((DEV_ADD<<1)|1);		//device address with LSB one is a read
			i2c_transfer();
			_delay_us(BIT_TIME/2);
			DDRB &= ~(1<<PINB5);
			if(!(PORTB & (1<<PINB5))){		//wait for ack
				DDRB |= (1<<PINB5);
				i2c_transfer();				//receive register value
				ret = USIDR;				//read data register
				i2c_send_nack();
				i2c_send_stop();
				return(ret);
			}
		}
	}
}*/