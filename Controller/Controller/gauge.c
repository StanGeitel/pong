#include <avr/io.h>
#include "gauge.h"
#include "i2c.h"

void gauge_init(void){
	gauge_single_write(0x02, 0xFF);
	gauge_single_write(0x03, 0xFF);
}

void gauge_send_reg_add(uint8_t reg_address){
	i2c_send_start();
	i2c_send_data(GAUGE_ADD<<1);				//send device address and write
	i2c_get_ack();							//wait for acknowledge
	i2c_send_data(reg_address);				//send register address of MPU
	i2c_get_ack();							//wait for acknowledge
}

uint8_t gauge_single_read(uint8_t reg_address){
	uint8_t ret;
	gauge_send_reg_add(reg_address);
	i2c_send_start();
	i2c_send_data((GAUGE_ADD<<1) & 1);			//device address and read
	i2c_get_ack();
	ret = i2c_get_data();
	i2c_send_nack();
	i2c_send_stop();
	return(ret);
}

void gauge_single_write(uint8_t reg_address, uint8_t data){
	gauge_send_reg_add(reg_address);
	i2c_send_data(data);
	i2c_get_ack();
	i2c_send_stop();
}

uint8_t gauge_double_read(uint8_t reg_address){
	uint8_t ret1;
	uint8_t ret2;
	gauge_send_reg_add(reg_address);
	i2c_send_start();
	i2c_send_data((GAUGE_ADD<<1) & 1);			//device address and read
	i2c_get_ack();
	ret1 = i2c_get_data();
	i2c_send_ack();
	ret2 = i2c_get_data();
	i2c_send_nack();
	i2c_send_stop();
	return(ret1); // ret 2 moet ook mee
}

