#include <avr/io.h>
#include <avr/common.h>
#include <avr/interrupt.h>
#include "buttons.h"
#include "uart.h"

#include "acc.h"
#include "i2c.h"

volatile uint8_t old_buttons = 0x0;

void buttons_init(){
	DDRB &= ~((1<<PINB3)|(1<<PINB2)|(1<<PINB1)|(1<<PINB0));				//set buttons as input
	PCMSK0 |= ((1<<PINB3)|(1<<PINB2)|(1<<PINB1)|(1<<PINB0));			//set buttons as source for pin change interrupt 0
	GIMSK |= (1<<PCIE0);												//enable pin change interrupt 0
	SREG |= (1<<SREG_I);												//enable interrupts I in global status register
	
	uart_init();
}

ISR(PCINT0_vect){		
	uint8_t new_buttons = (PINB & 0xF);
	uint8_t temp = (new_buttons ^ old_buttons);
	if((temp & (1<<PINB0)) && (old_buttons & (1<<PINB0))){
		uart_put_com(0xBB, 0xBB);
	}
	if((temp & (1<<PINB1)) && (old_buttons & (1<<PINB1))){
		uart_put_com(0x44, 0x44);
	}
	if((temp & (1<<PINB2)) && (old_buttons & (1<<PINB2))){
		uart_put_com(0x11, 0x11);
	}
	if((temp & (1<<PINB3)) && (old_buttons & (1<<PINB3))){
		uart_put_com(0x77, 0x77);
	}
	old_buttons = new_buttons;
}
