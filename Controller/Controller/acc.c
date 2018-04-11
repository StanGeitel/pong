#include <avr/io.h>
#include <avr/interrupt.h>

#include "acc.h"
#include "i2c.h"

uint16_t x_noise, y_noise;
uint8_t ovf_counter = 0;

void acc_init(){
	i2c_init();
	i2c_single_write(ACC_ADD, PWR_MAN, 0x00);		//turn off sleep mode
//	i2c_single_write(ACC_ADD, ACC_CON, 0x00);		//set range on +/- 2g
	i2c_single_write(ACC_ADD, INT_EN, 0x01);		//enable interrupt pin on data ready
	
	MCUCR |= (1 << ISC00);
	MCUCR |= (1 << ISC01);							//The rising edge of INT0 generates an interrupt request
	GIMSK |= (1 << INT0);							//enable external interrupt 0 in general interrupt mask register
	
	TCCR1A = (0<<COM1A1)|(0<<COM1A0)|(0<<COM1B1)|(0<<COM1B0)|(0<<WGM11)|(0<<WGM10);
	TCCR1B = (0<<ICNC1)|(0<<ICES1)|(0<<WGM13)|(0<<WGM12)|(0<<CS12)|(0<<CS11)|(0<<CS10);		//no clock, clear timer on compare
	TIMSK |= (1<<TOIE1);							//enable overflow interrupt
	SREG |= (1<<SREG_I);							//enable interrupts I in global status register
	
//	acc_calibrate();
}

void acc_calibrate(){
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
/*	uint16_t time = 0;
	time = TCNT1;
	TCNT1 = 0x0000;
	ovf_counter = 0;
*/	
	i2c_burst_read(ACC_ADD, X_MSB);
}

ISR(TIMER1_OVF_vect){
	ovf_counter++;
}

 