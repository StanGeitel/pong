#include <avr/io.h>
#include "gauge.h"
#include "i2c.h"
// #include "gpio.h"

void gauge_init(void){
	gauge_single_write(CHARGE_MSB, 0xFF);
	gauge_single_write(CHARGE_LSB, 0xFF);
}

void gauge_send_reg_add(uint8_t reg_address){
	i2c_send_start();
	i2c_send_data(GAUGE_ADD<<1);				//send device address and write
	i2c_get_ack();							//wait for acknowledge
	i2c_send_data(reg_address);				//send register address of MPU
	i2c_get_ack();							//wait for acknowledge
}
/*
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
*/

void gauge_single_write(uint8_t reg_address, uint8_t data){
	gauge_send_reg_add(reg_address);
	i2c_send_data(data);
	i2c_get_ack();
	i2c_send_stop();
}

void gauge_batterylevel(){
	uint16_t buffer;
	gauge_send_reg_add(CHARGE_MSB);
	i2c_send_start();
	i2c_send_data((GAUGE_ADD<<1) & 1);			//device address and read
	i2c_get_ack();
	buffer = (i2c_get_data() << 8);
	i2c_send_ack();
	buffer |= i2c_get_data();
	i2c_send_nack();
	i2c_send_stop();
	
	// q(LSB) ? 42,5 uAh daardoor nemen registers C en D 48235,29 stappen af in totaal (van 100-0 %)
	// 17301 is 0% en 31771,5 is 30% en 65535 is 100%
	
	if (buffer > 31772){
		// void dat led constant aan staat
	}
	else{
		// void dat led knippert
	}
	
}

/*for AL_CC 

 void init_external_interrupt1_gpio(void){
	 MCUCR |= (1 << ISC10);				//The rising edge of INT1 generates an interrupt request
	 MCUCR |= (1 << ISC11);
	 
	 GIMSK |= (1 << INT1);				//enable external interrupt 1 in general interrupt mask register
	 SREG |= (1 << SREG_I);				//enable interrupts I in global status register
 }
 
 ISR(INT1_vect){						//External interrupt1 service routine
	 
 }
*/
