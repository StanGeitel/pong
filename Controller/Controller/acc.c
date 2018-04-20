#include <avr/io.h>
#include <avr/interrupt.h>

#include "acc.h"
#include "i2c.h"
#include "uart.h"

uint16_t x_acc[2], y_acc[2];
uint16_t x_vel[2], y_vel[2];
uint16_t x_pos[2], y_pos[2];
uint16_t x_noise = 0, y_noise = 0;
uint8_t ovf_counter = 0;

void acc_init(){
	i2c_init();
	i2c_single_write(ACC_ADD, PWR_MAN, 0x00);		//turn off sleep mode
	i2c_single_write(ACC_ADD, ACC_CON, 0x00);		//set range on +/- 2g
	i2c_single_write(ACC_ADD, SMPRT_DIV, 0x08);		//1kHz sample rate and interrupt rate
	i2c_single_write(ACC_ADD, INT_CON, 0x10);		//clear interrupt on any read
	i2c_single_write(ACC_ADD, INT_EN, 0x01);		//enable interrupt on data ready

	uart_init();
/*	
	TCCR1A = (0<<COM1A1)|(0<<COM1A0)|(0<<COM1B1)|(0<<COM1B0)|(0<<WGM11)|(0<<WGM10);
	TCCR1B = (0<<ICNC1)|(0<<ICES1)|(0<<WGM13)|(0<<WGM12)|(0<<CS12)|(0<<CS11)|(0<<CS10);		//no clock, clear timer on compare
	TIMSK |= (1<<TOIE1);							//enable overflow interrupt
*/	
	MCUCR |= (1 << ISC00);
	MCUCR |= (1 << ISC01);							//The rising edge of INT0 generates an interrupt request
	GIMSK |= (1 << INT0);							//enable external interrupt 0 in general interrupt mask register
	
	SREG |= (1<<SREG_I);							//enable interrupts I in global status register
}
/*
void acc_calibrate(){
	uint16_t count = 0;
	x_acc[0] = x_acc[1] = y_acc[0] = y_acc[1] = x_vel[0] = x_vel[1] = y_vel[0] = y_vel[1] =	x_pos[0] = x_pos[1] = y_pos[0] = y_pos[1] = 0;	
	do{
		x_noise += i2c_burst_read(ACC_ADD, X_MSB);
		y_noise += i2c_burst_read(ACC_ADD, Y_MSB);
		count++;
	}while(count != 0x0400);
	
	x_noise = (x_noise>>10);
	y_noise = (y_noise>>10);

}
*/

ISR(INT0_vect){		//External interrupt0 service routine
/*	uint16_t time = 0;
	time = TCNT1;
	TCNT1 = 0x0000;
	ovf_counter = 0;

	uint8_t temp_8[2];
	uint8_t count = 0;
	
	do{
		x_acc[1] = i2c_burst_read(ACC_ADD, X_MSB) + x_noise;
		y_acc[1] = i2c_burst_read(ACC_ADD, Y_MSB) + y_noise;
		count++;
	}while(count != 0x40);
	
	x_acc[1] = (x_acc[1]>>6);
	y_acc[1] = (y_acc[1]>>6);
	
	x_vel[1] = x_vel[0] + (x_acc[0] + ((x_acc[1] - x_acc[0])>>1));
	y_vel[1] = y_vel[0] + (y_acc[0] + ((y_acc[1] - y_acc[0])>>1));
	
	x_pos[1] = x_pos[0] + (x_vel[0] + ((x_vel[1] - x_vel[0])>>1));
	y_pos[1] = y_pos[0] + (y_vel[0] + ((y_vel[1] - y_vel[0])>>1));

	if(x_pos[1] != x_pos[0]){
		temp_8[1] = (x_pos[1]>>8);
		temp_8[0] = (x_pos[1]&0xFF);
		uart_put_com(temp_8[1], temp_8[0]);
	}
	if(y_pos[1] != y_pos[0]){
		temp_8[1] = (y_pos[1]>>8);
		temp_8[0] = (y_pos[1]&0xFF);
		uart_put_com(temp_8[1], temp_8[0]);
	}
	
	x_acc[0] = x_acc[1];
	y_acc[0] = y_acc[1];
	
	x_vel[0] = x_vel[1];
	y_vel[0] = y_vel[1];
	
	x_pos[0] = x_pos[1];
	y_pos[0] = y_pos[1];
*/
	test();
}

ISR(TIMER1_OVF_vect){
	ovf_counter++;
}

void test(){
	uint16_t temp_16;
	uint8_t temp_8[2];
	
	temp_16 = i2c_burst_read(ACC_ADD, X_MSB);
	temp_16 = i2c_burst_read(ACC_ADD, Y_MSB);

}
