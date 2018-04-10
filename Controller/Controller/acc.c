#include <avr/io.h>
#include <avr/interrupt.h>

#include "acc.h"
#include "i2c.h"

uint16_t x_acc[2], y_acc[2];
uint16_t x_vel[2], y_vel[2];
uint16_t x_pos[2], y_pos[2];
uint16_t x_noise, y_noise;

void acc_init(){
	i2c_init();
	i2c_single_write(ACC_ADD, PWR_MAN, 0x00);		//turn off sleep mode
//	i2c_single_write(ACC_ADD, ACC_CON, 0x00);		//set range on +/- 2g
	i2c_single_write(ACC_ADD, INT_EN, 0x01);		//enable interrupt pin on data ready
	
	MCUCR |= (1 << ISC00);
	MCUCR |= (1 << ISC01);				//The rising edge of INT0 generates an interrupt request
	GIMSK |= (1 << INT0);				//enable external interrupt 0 in general interrupt mask register
	
	TCCR1A = (0<<COM1A1)|(0<<COM1A0)|(0<<COM1B1)|(0<<COM1B0)|(0<<WGM11)|(0<<WGM10);
	TCCR1B = (0<<ICNC1)|(0<<ICES1)|(0<<WGM13)|(0<<WGM12)|(0<<CS12)|(0<<CS11)|(0<<CS10);		//no clock, clear timer on compare
	OCR1AH = 0x00;
	OCR1AL = 0x05;							//match compare after 5 pulses
	TIMSK |= (1<<OCIE1A);					//enable interrupt on output compare A match
	SREG |= (1 << SREG_I);					//enable interrupts I in global status register
	
	acc_calibrate();
}

void acc_run(){
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
/*	
	if(x_pos[1] != x_pos[0]){
		uart_put_com()
	}
	if(y_pos[1] != y_pos[0]){
		uart_put_com()
	}
*/	
	x_acc[0] = x_acc[1];
	y_acc[0] = y_acc[1];
	
	x_vel[0] = x_vel[1];
	y_vel[0] = y_vel[1];
	
	x_pos[0] = x_pos[1];
	y_pos[0] = y_pos[1];
}

void acc_calibrate(){
	x_acc[0] = x_acc[1] = y_acc[0] = y_acc[1] = x_vel[0] = x_vel[1] = y_vel[0] = y_vel[1] =	x_pos[0] = x_pos[1] = y_pos[0] = y_pos[1] = 0;
	
	uint16_t count = 0;
	do{
		x_noise += i2c_burst_read(ACC_ADD, X_MSB);
		y_noise += i2c_burst_read(ACC_ADD, Y_MSB);
		count++;
	}while(count != 0x0400);
	
	x_noise = (x_noise>>10);
	y_noise = (y_noise>>10);
}


ISR(INT0_vect){		//External interrupt0 service routine
		
}

ISR(TIMER1_COMPA_vect){
	
}

 