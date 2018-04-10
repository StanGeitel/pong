#include <avr/io.h>
#include <avr/common.h>
#include <avr/interrupt.h>
#include "gpio.h"
#include "usart.h"
#include "acc.h"

volatile uint8_t old_buttons = 0x0;

void gpio_init(){
	DDR(_PORT) &= ~((1<<B3)|(1<<B2)|(1<<B1)|(1<<B0));				//set buttons as input
	PORT(_PORT) |= (1<<L0);											//enable pull up on led
	DDR(_PORT) |= (1<<L0);											//set led as output
	PCMSK0 |= ((1<<B3)|(1<<B2)|(1<<B1)|(1<<B0));					//set buttons as source for pin change interrupt 0
	GIMSK |= (1<<PCIE0);											//enable pin change interrupt 0

	TCCR0A = ((0<<COM0A1)|(0<<COM0A0)|(0<<COM0B1)|(0<<COM0B0)|(0<<WGM01)|(0<<WGM00));	//normal mode
	TCCR0B = ((0<<WGM02)|(0<<CS02)|(0<<CS01)|(0<<CS00));			//stop timer
	TIMSK |= (1<<TOIE0);											//enable overflow interrupt
	SREG |= (1<<SREG_I);											//enable interrupts I in global status register
	//results in ~30ms timer before checking the buttons states
}

ISR(PCINT0_vect){
	TCNT0 = 0x00;
	TCCR0B |= ((1<<CS02)|(0<<CS01)|(1<<CS00));					//Select 8MHz clock with 1024 prescaler
}

ISR(TIMER0_OVF_vect){
	TCCR0B &= ~((1<<CS02)|(1<<CS01)|(1<<CS00));					//stop timer
	
	uint8_t new_buttons = (PIN(_PORT) & 0xF);
	uint8_t temp = (new_buttons ^ old_buttons);
	if((temp & (1<<B0)) && (!(old_buttons & (1<<B0)))){
		PORT(_PORT) ^= (1<<L0);
		//uart_put_com((B0_COM<<2), (PIN(_PORT) & (1<<B0));
	}
	if((temp & (1<<B1)) && (!(old_buttons & (1<<B1)))){
		PORT(_PORT) ^= (1<<L0);
		//uart_put_com((B1_COM<<2), (PIN(_PORT) & (1<<B1));
	}
	if((temp & (1<<B2)) && (!(old_buttons & (1<<B2)))){
		PORT(_PORT) ^= (1<<L0);
		//uart_put_com((B2_COM<<2), (PIN(_PORT) & (1<<B2));
	}
	if((temp & (1<<B3)) && (!(old_buttons & (1<<B3)))){
		PORT(_PORT) ^= (1<<L0);
		//acc_calibrate();
	}
	old_buttons = new_buttons;	
}

