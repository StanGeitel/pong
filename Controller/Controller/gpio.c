#include <avr/io.h>
#include <avr/common.h>
#include <avr/interrupt.h>
#include "gpio.h"
#include "usart.h"
#include "acc.h"

volatile uint8_t old_buttons = 0;

void gpio_init(){
	DDR(_PORT) &= ~((1<<B3)|(1<<B2)|(1<<B1)|(1<<B0));	//set buttons as input
	PORT(_PORT) |= (1<<L0);								//enable pull up on led
	DDR(_PORT) |= (1<<L0);								//set led as output
	
	PCMSK0 |= ((1<<B3)|(1<<B2)|(1<<B1)|(1<<B0));		//set buttons as source for pin change interrupt 0
	GIMSK |= (1<<PCIE0);								//enable pin change interrupt 0
	SREG |= (1<<SREG_I);								//enable interrupts I in global status register
}

void gpio_set_led(){
	PORT(_PORT) &= ~(1<<L0); 
}

void gpio_reset_led(){
	PORT(_PORT) |= (1<<L0);
}
 
ISR(PCINT0_vect){
	uint8_t new_buttons = PORT(_PORT) & 0xF;
	uint8_t temp = new_buttons ^ old_buttons;
	if(temp & (1<<B0)){		
		if(!(old_buttons&(1<<B0))){
			PORT(_PORT) ^= (1<<L0);
			uart_put_com((B0_COM<<2), (PORT(_PORT)>>B0));
		}
	}
	if(temp & (1<<B1)){	
		if(!(old_buttons&(1<<B1))){
			PORT(_PORT) ^= (1<<L0);
			uart_put_com((B1_COM<<2), (PORT(_PORT)>>B1));
		}
	}
	if(temp & (1<<B2)){
		if(!(old_buttons&(1<<B2))){
			PORT(_PORT) ^= (1<<L0);
			uart_put_com((B2_COM<<2), (PORT(_PORT)>>B2));
		}
	}
	
	if(temp & (1<<B3)){									//calibration button
		if(!(old_buttons&(1<<B2))){
			PORT(_PORT) ^= (1<<L0);
			acc_calibrate();
		}
	}
	old_buttons = new_buttons;
}
