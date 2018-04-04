#include <avr/io.h>
#include <avr/common.h>
#include <avr/interrupt.h>
#include <stdint.h>
#include "gpio.h"

volatile uint8_t old_pins = 0;

 void set_output_gpio(unsigned char port, int pin){
	DDR(port) &= ~(1 << pin);
	PORT(port) |= (1 << pin);

	DDR(port) |= (1 << pin);
	PORT(port) |= (1 << pin);
 }

 void clear_output_gpio(unsigned char port, int pin){
	DDR(port) &= ~(1 << pin);
	PORT(port) &= ~(1 << pin);
	
	DDR(port) |= (1 << pin);
	PORT(port) &= ~(1 << pin);
 }

 void toggle_output_gpio(unsigned char port, int pin){
	 DDR(port) |= (1 << pin);
	 PORT(port) ^= (1 << pin);//toggle bit om register with exor
 }

 void enable_input_gpio(unsigned char port, int pin){
	DDR(port) &= ~(1 << pin);
 }
 
 void enable_pullup_gpio(unsigned char port, int pin){
	PORT(port) |= (1 << pin);
 }

 int read_gpio(unsigned char port, int pin){
	int ret = (PIN(port) & (1 << pin));
	return(ret);
 }

 void init_pin_change_interrupt_gpio(int pcint){
	if(pcint <= 7){
		PCMSK0 |= (1 << pcint);
		GIMSK |= (1 << PCIE0);
	}
	else if(pcint >= 8 && pcint <=10){
		PCMSK1 |= (1 << pcint);
		GIMSK |= (1 << PCIE1);
	}
	else if(pcint >= 11 && pcint <=17){
		PCMSK2 |= (1 << pcint);			//enable interrupt on pin pcint in pin change mask 2 register
		GIMSK |= (1 << PCIE2);			//enable pin change interrupt 2 in general interrupt mask register	
	}
	SREG |= (1 << SREG_I);				//enable interrupts I in global status register
	int i;
	for(i = 0; i < 6; i++){
		enable_input_gpio('B', i);
	}
 }
 
 
 //ISR(PCINT1_vect){						//Pin change interrupt1 service routine
//	
 //}
  
// ISR(PCINT2_vect){						//Pin change interrupt2 service routine 
//	
// }
 

 void init_external_interrupt1_gpio(void){
	 MCUCR |= (1 << ISC10);				//The rising edge of INT1 generates an interrupt request
	 MCUCR |= (1 << ISC11);
	 
	 GIMSK |= (1 << INT1);				//enable external interrupt 1 in general interrupt mask register
	 SREG |= (1 << SREG_I);				//enable interrupts I in global status register
 }
 
 ISR(INT1_vect){						//External interrupt1 service routine
	  
 }