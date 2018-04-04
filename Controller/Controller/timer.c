 #include <avr/io.h>
 #include <avr/common.h>
 #include <avr/interrupt.h>
 #include "timer.h"

 void init_timer0(void){
	DDRB |= (1<<DDB2);
	TCCR0A = (0<<COM0A1)|(0<<COM0A0)|(0<<COM0B1)|(0<<COM0B0)|(0<<WGM01)|(0<<WGM00);
	TCCR0B = (0<<WGM02)|(0<<CS02)|(0<<CS01)|(1<<CS00);		//Select 8MHz clock with no prescaler
	OCR0A = 160;											//Set match register on 10 pulses
	OCR0B = 9;
	TIMSK |= (1<<OCIE0A)|(1<<OCIE0B);
	SREG |= (1<<SREG_I);								//enable global interrupt
 }
 
 ISR(TIMER0_COMPA_vect){
	TCCR0B &= ~((1<<CS02)|(1<<CS01)|(1<<CS00));
	TCNT0 = 0x00;
 }
 
 ISR(TIMER0_COMPB_vect){
	OCR0B += 10;
	PORTB ^= (1<<2);
 }