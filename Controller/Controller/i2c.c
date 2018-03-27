#define F_CPU				1000000UL		//1MHz
#include <avr/io.h>
#include <util/delay.h>

#include "i2c.h"

uint8_t buffer;

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

void i2c_transfer(){				//generates 8 clock pulses
	for(int i = 0; i < 8; i++){
		PORTB |= (1<<PINB7);			//release SCL
		while(!(PORTB & (1<<PINB7)));	//wait for SCL to go high
		_delay_ms(1000);
		PORTB &= ~(1<<PINB7);
		_delay_ms(1000);
	}
	_delay_us(BIT_TIME);
}

uint8_t i2c_get_ack(){
	uint8_t ret;
	
	DDRB &= ~(1<<PINB5);					//set as input
	PORTB &= ~(1<<PINB5);					//disable pull up
	
	PORTB |= (1<<PINB7);					//release SCL
	while(!(PORTB & (1<<PINB7)));			//wait for SCL to go high
	if(PORTB & (1<<PINB5)){					//read SDA
		ret = 1;
	}else{
		ret = 0;
	}
	_delay_us(BIT_TIME);					//wait a bit
	PORTB &= ~(1<<PINB7);					//force SCL low
	
	PORTB |= (1<<PINB5);					//enable pull up
	DDRB |= (1<<PINB5);						//set as output
	return(ret);
}

uint8_t i2c_get_data(){
	uint8_t ret;
	DDRB &= ~(1<<PINB5);				//set as input
	PORTB &= ~(1<<PINB5);				//disable pull up
	i2c_transfer();							
	ret = USIDR;						//read data register
	USIDR = 0xFF;						//reset data register
	return(ret);
}

void i2c_send_reg_add(uint8_t reg_address){
	i2c_send_start();
	USIDR = (DEV_ADD<<1);				//device address and write
	i2c_transfer();						//send
	USIDR = 0xFF;						//reset data register
	i2c_get_ack();						//wait for acknowledge
	
	USIDR = reg_address;				//write register address
	i2c_transfer();						//send
	USIDR = 0xFF;						//reset data register
	i2c_get_ack();						//wait for acknowledge
}

uint8_t i2c_single_read(uint8_t reg_address){
	uint8_t ret;

	i2c_send_reg_add(reg_address);
	i2c_send_start();
	USIDR = ((DEV_ADD<<1) & 1);			//device address and read
	i2c_transfer();
	i2c_get_ack();
	ret = i2c_get_data();
	i2c_send_nack();
	i2c_send_stop();
	return(ret);
}

void i2c_single_write(uint8_t reg_address, uint8_t data){
	i2c_send_reg_add(reg_address);
	USIDR = data;
	i2c_transfer();
	USIDR = 0xFF;
	i2c_get_ack();
	i2c_send_stop();
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