#include <avr/io.h>
#include "acc.h"
#include "i2c.h"

uint16_t x_pos = 0;
uint16_t y_pos = 0;

void acc_init(){
	i2c_init();
}

void acc_send_reg_add(uint8_t reg_address){
	i2c_send_start();
	i2c_send_data(ACC_ADD<<1);				//send device address and write
	i2c_get_ack();							//wait for acknowledge
	i2c_send_data(reg_address);				//send register address of MPU
	i2c_get_ack();							//wait for acknowledge
}

uint8_t acc_single_read(uint8_t reg_address){
	uint8_t ret;
	acc_send_reg_add(reg_address);
	i2c_send_start();
	i2c_send_data((ACC_ADD<<1) & 1);			//device address and read
	i2c_get_ack();
	ret = i2c_get_data();
	i2c_send_nack();
	i2c_send_stop();
	return(ret);
}

void acc_single_write(uint8_t reg_address, uint8_t data){
	acc_send_reg_add(reg_address);
	i2c_send_data(data);
	i2c_get_ack();
	i2c_send_stop();
}

 void init_external_interrupt0(){
	 MCUCR |= (1 << ISC00);
	 MCUCR |= (1 << ISC01);				//The rising edge of INT0 generates an interrupt request
	 
	 GIMSK |= (1 << INT0);				//enable external interrupt 0 in general interrupt mask register
	 SREG |= (1 << SREG_I);				//enable interrupts I in global status register
 }
 /*
 ISR(INT0_vect){						//External interrupt0 service routine
	 
 }
 */
 