#define F_CPU				8000000UL		//8MHz
#include <avr/io.h>
#include <util/delay.h>

#include "i2c.h"

void i2c_init(){
	USIDR = 0xFF;							//set data register high for start condition
	PORT(_PORT) = (1<<_SDA)|(1<<_SCL);		//set HIGH with pull up.
	DDR(_PORT) = (1<<_SDA)|(1<<_SCL);		//enable output driver for SDA and SCL.
	//SDA corresponds with MSB of USIDR and PORTB bit. SCL is high unless forced low by start detector or bit PORTB register.
	USICR = (0<<USISIE)|(0<<USISIE)|(1<<USIWM1)|(0<<USIWM0)|(1<<USICS1)|(0<<USICS0)|(1<<USICLK)|(0<<USITC);
	USISR = (1<<USISIF)|(1<<USIOIF)|(1<<USIPF)|(1<<USIDC)|(0x0<<USICNT0);		//reset flags and counter value
}

void i2c_send_start(){
	PORT(_PORT) = (1<<_SDA)|(1<<_SCL);		//release both for start condition
	while((!(PORT(_PORT)&(1<<_SCL)))|(!(PORT(_PORT)&(1<<_SDA))));
	PORT(_PORT) &= ~(1<<_SDA);				//force SDA low
	_delay_us(BIT_TIME);
	PORT(_PORT) &= ~(1<<_SCL);				//force SCL low
}

void i2c_send_stop(){
	PORT(_PORT) &= ~(1<<_SDA);				//force SDA low
	PORT(_PORT) |= (1<<_SCL);				//release SCL
	_delay_us(BIT_TIME);
	PORT(_PORT) |= (1<<_SDA);				//release SDA
}

void i2c_send_ack(){
	PORT(_PORT) &= ~(1<<_SDA);				//force SDA low
	PORT(_PORT) |= (1<<_SCL);				//release SCL
	_delay_us(BIT_TIME);
	PORT(_PORT) &= ~(1<<_SCL);				//force SCL low
	PORT(_PORT) |= (1<<_SDA);				//release SDA
}

void i2c_send_nack(){
	PORT(_PORT) |= (1<<_SDA);				//release SDA
	PORT(_PORT) |= (1<<_SCL);				//release SCL
	_delay_us(BIT_TIME);
	PORT(_PORT) &= ~(1<<_SCL);				//force SCL low
}

uint8_t i2c_get_ack(){
	uint8_t ret = 0;
	DDR(_PORT) &= ~(1<<_SDA);					//set SDA as input
	USICR |= (1<<USITC);						//toggle SCL to HIGH
	_delay_us(BIT_TIME);
	USICR |= (1<<USITC);						//toggle SCL to LOW
	_delay_us(BIT_TIME);
	ret = (USIDR & 1);
	USIDR = 0xFF;
	DDR(_PORT) |= (1<<_SDA);					//set as SDA as output
	return(ret);
}

void i2c_send_data(uint8_t data){
	USIDR = data;
	PORT(_PORT) |= (1<<_SDA);
	USISR &= ~(0xF<<USICNT0);					//reset counter
	do{
		USICR |= (1<<USITC);					//toggle SCL to HIGH
		_delay_us(BIT_TIME);
		USICR |= (1<<USITC);					//toggle SCL to LOW
		_delay_us(BIT_TIME);
	}while(!(USISR & (1<<USIOIF)));				//check counter overflow flag
	
	USIDR = 0xFF;
}

uint8_t i2c_get_data(){
	uint8_t ret;
	DDR(_PORT) &= ~(1<<_SDA);					//set SDA as input
	USISR &= ~(0xF << USICNT0);					//reset counter
	do{
		USICR |= (1<<USITC);					//toggle SCL to HIGH
		_delay_us(BIT_TIME);
		USICR |= (1<<USITC);					//toggle SCL to LOW
		_delay_us(BIT_TIME);
	}while(!(USISR & (1<<USIOIF)));				//check counter overflow flag
	ret = USIDR;
	USIDR = 0xFF;
	DDR(_PORT) |= (1<<_SDA);					//set as SDA as output
	return(ret);
}
