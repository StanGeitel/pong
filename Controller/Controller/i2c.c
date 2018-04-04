#define F_CPU				8000000UL		//8MHz
#include <avr/io.h>
#include <util/delay.h>

#include "i2c.h"

void i2c_init(){
	PORT(_PORT) = (1<<_SCL)|(1<<_SDA);		//set HIGH with pull up.
	DDR(_PORT) = (1<<_SCL)|(1<<_SDA);		//enable output driver for SDA and SCL.
}

void i2c_send_start(){
	PORT(_PORT) &= ~(1<<_SDA);				//force SDA low
	while(PORT(_PORT) & (1<<_SDA));			//wait for SDA low
	_delay_us(BIT_TIME);
	PORT(_PORT) &= ~(1<<_SCL);				//force SCL low
	PORT(_PORT) |= (1<<_SCL);				//release SCL
}

void i2c_send_stop(){
	PORT(_PORT) &= ~(1<<_SDA);				//force SDA low
	while(PORT(_PORT) & (1<<_SDA));			//wait for SDA low
	PORT(_PORT) |= (1<<_SCL);				//release SCL
	while(!(PORT(_PORT) & (1<<_SCL)));		//wait for SCL high
	_delay_us(BIT_TIME);
	PORT(_PORT) |= (1<<_SDA);				//release SDA
	_delay_us(BIT_TIME);
}

void i2c_send_ack(){
	PORT(_PORT) &= ~(1<<_SDA);				//force SDA low
	while(PORT(_PORT) & (1<<_SDA));			//wait for SDA to go low
	PORT(_PORT) |= (1<<_SCL);				//release SCL
	while(!(PORT(_PORT) & (1<<_SCL)));		//wait for SCL to go high
	_delay_us(BIT_TIME);
	PORT(_PORT) &= ~(1<<_SCL);				//force SCL low
	PORT(_PORT) |= (1<<_SDA);				//release SDA
}

void i2c_send_nack(){
	PORT(_PORT) |= (1<<_SDA);				//release SDA
	while(!(PORT(_PORT) & (1<<_SDA)));		//wait for SDA to go high
	PORT(_PORT) |= (1<<_SCL);				//release SCL
	while(!(PORT(_PORT) & (1<<_SCL)));		//wait for SCL to go high
	PORT(_PORT) &= ~(1<<_SCL);				//force SCL low
}

uint8_t i2c_get_ack(){
	uint8_t ret;
	
	DDR(_PORT) &= ~(1<<_SDA);					//set SDA as input
//	PORT(_PORT) &= ~(1<<_SDA);					//disable SDA pull up
	
	PORT(_PORT) |= (1<<_SCL);					//release SCL
	while(!(PORT(_PORT) & (1<<_SCL)));			//wait for SCL to go high
	
	if(PORT(_PORT) & (1<<_SDA)){				//read if SDA is 1
		ret = 1;
	}else{
		ret = 0;
	}
	_delay_us(BIT_TIME);						//wait a bit
	PORT(_PORT) &= ~(1<<_SCL);					//force SCL low
	
	PORT(_PORT) |= (1<<_SDA);					//enable SDA pull up
	DDR(_PORT) |= (1<<_SDA);					//set as SDA as output
	return(ret);
}

void i2c_send_data(uint8_t data){
	PORT(_PORT) &= ~(1<<_SCL);					//pull SCL low
	for(int i = 0; i < 8; i++){
		while(PORT(_PORT) & (1<<_SCL));			//wait for SCL to go low
		
		PORT(_PORT) = (((data>>i) & 1)<<_SDA);
		
		PORT(_PORT) |= (1<<_SCL);				//release SCL
		while(!(PORT(_PORT) & (1<<_SCL)));		//wait for SCL to go high
		_delay_us(BIT_TIME);
		PORT(_PORT) &= ~(1<<_SCL);				//force SCL low
		_delay_us(BIT_TIME);
	}
}


uint8_t i2c_get_data(){
	uint8_t buf = 0;
	
	DDR(_PORT) &= ~(1<<_SDA);					//set SDA as input
	PORT(_PORT) &= ~(1<<_SDA);					//disable pull up
	
	PORT(_PORT) &= ~(1<<_SCL);					//pull SCL low
	for(int i = 0; i <= 7; i++){				//count bit 0 to 7
		while(PORT(_PORT) & (1<<_SCL));			//wait for SCL to go low
		
		if(PORT(_PORT) & (1<<_SDA)){			//read if SDA is 1
			buf |= (1<<i);						//write bit on position i 1
		}else{
			buf &= ~(1<<i);						//write bit on position i 0
		}
		
		PORT(_PORT) |= (1<<_SCL);				//release SCL
		while(!(PORT(_PORT) & (1<<_SCL)));		//wait for SCL to go high
		_delay_us(BIT_TIME);
		PORT(_PORT) &= ~(1<<_SCL);				//force SCL low
		_delay_us(BIT_TIME);
	}
	
	PORT(_PORT) |= (1<<_SDA);					//enable SDA pull up
	DDR(_PORT) |= (1<<_SDA);					//set as SDA as output
	
	return(buf);
}

void usi_init(){	
	USIDR = 0xFF;							//set data register high for start condition
	PORT(_PORT) = (1<<_SDA)|(1<<_SCL);		//set HIGH with pull up.
	DDR(_PORT) = (1<<_SDA)|(1<<_SCL);		//enable output driver for SDA and SCL.
	//SDA corresponds with MSB of USIDR and PORTB bit. SCL is high unless forced low by start detector or bit PORTB register.
	USICR = (0<<USISIE)|(0<<USISIE)|(1<<USIWM1)|(0<<USIWM0)|(1<<USICS1)|(0<<USICS0)|(1<<USICLK)|(0<<USITC);
	USISR = (1<<USISIF)|(1<<USIOIF)|(1<<USIPF)|(1<<USIDC)|(0x0<<USICNT0);		//reset flags and counter value
}

void usi_send(uint8_t data){
	PORT(_PORT) |= (1<<_SCL);					//release SCL
	USICR |= (1<<USITC);						//toggle SCL to HIGH
	USISR &= ~(0xF<<USICNT0);					//reset counter
	USIDR = data;
	PORT(_PORT) |= (1<<_SDA);
	do{
		USICR |= (1<<USITC);					//toggle SCL to HIGH
		_delay_us(BIT_TIME);
		USICR |= (1<<USITC);					//toggle SCL to LOW
		_delay_us(BIT_TIME);
	}while(!(USISR & (1<<USIOIF)));				//check counter overflow flag
	USIDR = 0xFF;
}

uint8_t usi_read(){
	uint8_t ret = 0;
	DDR(_PORT) &= ~(1<<_SDA);					//set SDA as input
	PORT(_PORT) &= ~(1<<_SDA);					//disable pull up
	USISR &= ~(0xF << USICNT0);					//reset counter
	do{
		USICR |= (1<<USITC);					//toggle SCL to HIGH
		_delay_us(BIT_TIME);
		USICR |= (1<<USITC);					//toggle SCL to LOW
		_delay_us(BIT_TIME);
	}while(!(USISR & (1<<USIOIF)));				//check counter overflow flag
	ret = USIDR;
	USIDR = 0xFF;
	PORT(_PORT) |= (1<<_SDA);					//enable SDA pull up
	DDR(_PORT) |= (1<<_SDA);					//set as SDA as output
	return(ret);
}

