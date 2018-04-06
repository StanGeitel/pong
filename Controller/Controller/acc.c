#include <avr/io.h>
#include <avr/interrupt.h>
#include "acc.h"
#include "i2c.h"

uint16_t x_pos = 0;
uint16_t y_pos = 0;
uint16_t x_acc;
uint16_t y_acc;

void acc_init(){
	i2c_init();
	ext_int0_init();
	
	acc_single_write(ACC_CON, 0x00);		//set range on +/- 2g
	acc_single_write(INT_EN, 0x01);			//enable interrupt pin on data ready
	
}

void ext_int0_init(){
	MCUCR |= (1 << ISC00);
	MCUCR |= (1 << ISC01);				//The rising edge of INT0 generates an interrupt request
	GIMSK |= (1 << INT0);				//enable external interrupt 0 in general interrupt mask register
	SREG |= (1 << SREG_I);				//enable interrupts I in global status register
}

void acc_single_write(uint8_t reg_address, uint8_t data){
	acc_send_reg_add(reg_address);
	i2c_send_data(data);
	i2c_get_ack();
	i2c_send_stop();
}

void acc_burst_write(uint8_t reg_address, uint8_t data1, uint8_t data2){
	acc_send_reg_add(reg_address);
	i2c_send_data(data1);
	i2c_get_ack();
	i2c_send_data(data2);
	i2c_get_ack();
	i2c_send_stop();
}

uint8_t acc_single_read(uint8_t reg_address){
	uint8_t ret;
	acc_send_reg_add(reg_address);
	i2c_send_start();
	i2c_send_data((ACC_ADD<<1)|1);			//device address and read is 1
	i2c_get_ack();
	ret = i2c_get_data();
	i2c_send_nack();
	i2c_send_stop();
	return(ret);
}

uint16_t acc_burst_read(uint8_t reg_address){
	uint16_t ret;
	acc_send_reg_add(reg_address);
	i2c_send_start();
	i2c_send_data((ACC_ADD<<1)|1);			//device address and read is 1
	i2c_get_ack();
	ret = (i2c_get_data()<<8);
	i2c_send_ack();
	ret |= i2c_get_data();
	i2c_send_nack();
	i2c_send_stop();
}

void acc_send_reg_add(uint8_t reg_address){
	i2c_send_start();
	i2c_send_data(ACC_ADD<<1);				//send device address and write is 0
	i2c_get_ack();							//wait for acknowledge
	i2c_send_data(reg_address);				//send register address of MPU
	i2c_get_ack();							//wait for acknowledge
}

void acc_calc_x_pos(){
	
}

void acc_calc_y_pos(){
	
}

void acc_calibrate(){
	
}

ISR(INT0_vect){							//External interrupt0 service routine
	uint16_t temp;
	temp = acc_burst_read(X_MSB);
	if(temp != x_acc){
		x_acc = temp;
		acc_calc_x_pos();
	}else{
		temp = acc_burst_read(Y_MSB);
		if(temp != y_acc){
			y_acc = temp;
			acc_calc_y_pos();
		}
	}
}

 