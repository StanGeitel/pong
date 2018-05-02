#include <avr/io.h>
#include <avr/interrupt.h>

#include "acc.h"
#include "i2c.h"
#include "uart.h"

volatile static int16_t x_acc[2], y_acc[2];
volatile static int16_t x_vel[2], y_vel[2];
volatile static int16_t x_pos[2], y_pos[2];
volatile static int16_t x_noise = 0, y_noise = 0;

void acc_init(){
	i2c_single_write(ACC_ADD, PWR_MAN, 0x00);		//turn off sleep mode
	i2c_single_write(ACC_ADD, ACC_CON, 0x00);		//set range on +/- 2g
	i2c_single_write(ACC_ADD, SMPRT_DIV, 0x08);		//1kHz sample rate and interrupt rate
	i2c_single_write(ACC_ADD, INT_CON, 0x10);		//clear interrupt on any read
	i2c_single_write(ACC_ADD, INT_EN, 0x01);		//enable interrupt on data ready

	MCUCR |= (1 << ISC00);
	MCUCR |= (1 << ISC01);							//The rising edge of INT0 generates an interrupt request
	GIMSK |= (1 << INT0);							//enable external interrupt 0 in general interrupt mask register
	SREG |= (1<<SREG_I);							//enable interrupts I in global status register
}

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

ISR(INT0_vect){		//External interrupt0 service routine
	x_acc[1] = i2c_burst_read(ACC_ADD, X_MSB) + x_noise;
	y_acc[1] = i2c_burst_read(ACC_ADD, Y_MSB) + y_noise;
	
	if((x_acc[1] <= 50 && x_acc[1] >= -50) && (y_acc[1] <= 50 && y_acc[1] >= -50)){
		
	}
	x_vel[1] = x_vel[0] + (x_acc[0] + ((x_acc[1] - x_acc[0])>>1));
	y_vel[1] = y_vel[0] + (y_acc[0] + ((y_acc[1] - y_acc[0])>>1));
	
	x_pos[1] = x_pos[0] + (x_vel[0] + ((x_vel[1] - x_vel[0])>>1));
	y_pos[1] = y_pos[0] + (y_vel[0] + ((y_vel[1] - y_vel[0])>>1));
	
	uart_set_pos(x_pos[1], y_pos[1]);
	
	x_acc[0] = x_acc[1];
	y_acc[0] = y_acc[1];
	
	x_vel[0] = x_vel[1];
	y_vel[0] = y_vel[1];
	
	x_pos[0] = x_pos[1];
	y_pos[0] = y_pos[1];

}
