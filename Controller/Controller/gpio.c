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
	SREG |= (1<<SREG_I);											//enable interrupts I in global status register
}

ISR(PCINT0_vect){		
	uint8_t new_buttons = (PIN(_PORT) & 0xF);
	uint8_t temp = (new_buttons ^ old_buttons);
	if((temp & (1<<B0)) && (old_buttons & (1<<B0))){
		PORT(_PORT) ^= (1<<L0);
		uart_put_com(0xBB, 0xBB);
	}
	if((temp & (1<<B1)) && (old_buttons & (1<<B1))){
		PORT(_PORT) ^= (1<<L0);
		uart_put_com(0x44, 0x44);
	}
	if((temp & (1<<B2)) && (old_buttons & (1<<B2))){
		PORT(_PORT) ^= (1<<L0);
		uart_put_com(0x00, 0x00);
	}
	if((temp & (1<<B3)) && (old_buttons & (1<<B3))){
		PORT(_PORT) ^= (1<<L0);
		uart_put_com(0x99, 0x99);
		//acc_calibrate();
	}
	old_buttons = new_buttons;
}
