#define F_CPU		8000000UL		//8MHz 
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#include "i2c.h"

void i2c_single_write(uint8_t dev_address, uint8_t reg_address, uint8_t data){
	i2c_send_reg_add(dev_address, reg_address);
	i2c_send_data(data);
	i2c_get_ack();
	i2c_send_stop();
}

void i2c_burst_write(uint8_t dev_address, uint8_t reg_address, uint8_t data1, uint8_t data2){
	i2c_send_reg_add(dev_address, reg_address);
	i2c_send_data(data1);
	i2c_get_ack();
	i2c_send_data(data2);
	i2c_get_ack();
	i2c_send_stop();
}

uint8_t i2c_single_read(uint8_t dev_address, uint8_t reg_address){
	uint8_t ret;
	i2c_send_reg_add(dev_address, reg_address);
	i2c_send_start();
	i2c_send_data((dev_address<<1)|1);			//device address and read is 1
	i2c_get_ack();
	ret = i2c_get_data();
	i2c_send_nack();
	i2c_send_stop();
	return(ret);
}

uint16_t i2c_burst_read(uint8_t dev_address, uint8_t reg_address){
	uint16_t ret;
	i2c_send_reg_add(dev_address, reg_address);
	i2c_send_start();
	i2c_send_data((dev_address<<1)|1);			//device address and read is 1
	i2c_get_ack();
	ret = (i2c_get_data()<<8);
	i2c_send_ack();
	ret |= i2c_get_data();
	i2c_send_nack();
	i2c_send_stop();
	return(ret);
}

void i2c_send_reg_add(uint8_t dev_address, uint8_t reg_address){
	i2c_send_start();
	i2c_send_data(dev_address<<1);				//send device address and write is 0
	i2c_get_ack();							//wait for acknowledge
	i2c_send_data(reg_address);				//send register address of MPU
	i2c_get_ack();							//wait for acknowledge
}

void i2c_init(){
	USIDR = 0xFF;							//set data register high for start condition
	PORTB |= (1<<PINB5)|(1<<PINB7);		//set HIGH with pull up.
	DDRB |= (1<<PINB5)|(1<<PINB7);		//enable output driver for SDA and SCL.
	//SDA corresponds with MSB of USIDR and PORTB bit. SCL is high unless forced low by start detector or bit PORTB register.
	USICR = (0<<USISIE)|(0<<USISIE)|(1<<USIWM1)|(0<<USIWM0)|(1<<USICS1)|(0<<USICS0)|(1<<USICLK)|(0<<USITC);
	USISR = (1<<USISIF)|(1<<USIOIF)|(1<<USIPF)|(1<<USIDC)|(0x0<<USICNT0);		//reset flags and counter value
}

void i2c_send_start(){
	PORTB |= (1<<PINB5)|(1<<PINB7);		//release both for start condition
	while((!(PORTB&(1<<PINB7)))|(!(PORTB&(1<<PINB5))));
	PORTB &= ~(1<<PINB5);				//force SDA low
	_delay_us(BIT_TIME);
	PORTB &= ~(1<<PINB7);				//force SCL low
}

void i2c_send_stop(){
	PORTB &= ~(1<<PINB5);				//force SDA low
	PORTB |= (1<<PINB7);				//release SCL
	_delay_us(BIT_TIME);
	PORTB |= (1<<PINB5);				//release SDA
}

void i2c_send_ack(){
	PORTB &= ~(1<<PINB5);				//force SDA low
	PORTB |= (1<<PINB7);				//release SCL
	_delay_us(BIT_TIME);
	PORTB &= ~(1<<PINB7);				//force SCL low
	PORTB |= (1<<PINB5);				//release SDA
}

void i2c_send_nack(){
	PORTB |= (1<<PINB5);				//release SDA
	PORTB |= (1<<PINB7);				//release SCL
	_delay_us(BIT_TIME);
	PORTB &= ~(1<<PINB7);				//force SCL low
}

uint8_t i2c_get_ack(){
	uint8_t ret = 0;
	DDRB &= ~(1<<PINB5);					//set SDA as input
	USICR |= (1<<USITC);						//toggle SCL to HIGH
	_delay_us(BIT_TIME);
	USICR |= (1<<USITC);						//toggle SCL to LOW
	_delay_us(BIT_TIME);
	ret = (USIDR & 1);
	USIDR = 0xFF;
	DDRB |= (1<<PINB5);					//set as SDA as output
	return(ret);
}

void i2c_send_data(uint8_t data){
	USIDR = data;
	PORTB |= (1<<PINB5);
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
	DDRB &= ~(1<<PINB5);					//set SDA as input
	USISR &= ~(0xF << USICNT0);					//reset counter
	do{
		USICR |= (1<<USITC);					//toggle SCL to HIGH
		_delay_us(BIT_TIME);
		USICR |= (1<<USITC);					//toggle SCL to LOW
		_delay_us(BIT_TIME);
	}while(!(USISR & (1<<USIOIF)));				//check counter overflow flag
	ret = USIDR;
	USIDR = 0xFF;
	DDRB |= (1<<PINB5);					//set as SDA as output
	return(ret);
}

