#define F_CPU		8000000UL		//8MHz 
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#include "i2c.h"
#include "gpio.h"

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
	PORT(_PORT) |= (1<<_SDA)|(1<<_SCL);		//set HIGH with pull up.
	DDR(_PORT) |= (1<<_SDA)|(1<<_SCL);		//enable output driver for SDA and SCL.
	//SDA corresponds with MSB of USIDR and PORTB bit. SCL is high unless forced low by start detector or bit PORTB register.
	USICR = (0<<USISIE)|(0<<USISIE)|(1<<USIWM1)|(0<<USIWM0)|(1<<USICS1)|(0<<USICS0)|(1<<USICLK)|(0<<USITC);
	USISR = (1<<USISIF)|(1<<USIOIF)|(1<<USIPF)|(1<<USIDC)|(0x0<<USICNT0);		//reset flags and counter value
}

void i2c_send_start(){
	PORT(_PORT) |= (1<<_SDA)|(1<<_SCL);		//release both for start condition
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

/*
void delay(){
	TCNT1H = 0x00;
	TCNT1L = 0x00;
	TCCR1B |= (1<<CS10);						//start timer
}

void timer1_init(){
	TCCR1A = (0<<COM1A1)|(0<<COM1A0)|(0<<COM1B1)|(0<<COM1B0)|(0<<WGM11)|(0<<WGM10);
	TCCR1B = (0<<ICNC1)|(0<<ICES1)|(0<<WGM13)|(0<<WGM12)|(0<<CS12)|(0<<CS11)|(0<<CS10);		//no clock, clear timer on compare
	OCR1AH = 0x00;
	OCR1AL = 0x05;							//match compare after 5 pulses
	TIMSK |= (1<<OCIE1A);					//enable interrupt on output compare A match
	SREG |= (1<<SREG_I);					//enable interrupts I in global status register
}

ISR(TIMER1_COMPA_vect){
	PORT(_PORT) &= (1<<L0);
	
	TCCR1B &= ~(1<<CS10);						//stop timer
	timer_count = 1;
}
*/

