#define F_CPU		8000000UL		//8MHz 
#include <avr/io.h>
#include <avr/interrupt.h>

#include "uart.h"

volatile static uint8_t tx_buffer[2];
volatile static uint8_t size = 0;

void uart_init(void) {
	UBRRH = (uint8_t)(MYUBBR>>8);								//set baud rate
	UBRRL = (uint8_t)(MYUBBR);
	UCSRB = (1<<TXEN);											//enable transmit
	UCSRC = (1<<UPM1)|(0<<USBS)|(1<<UCSZ1)|(1<<UCSZ0);			//enable even parity, set 8-bit character, set 1 stop bit
	SREG |= (1<<SREG_I);										//enable interrupts I in global status register
}

void uart_put_com(uint8_t command, uint8_t data){
	while(size > 0);
	tx_buffer[1] = command;
	tx_buffer[0] = data;
	size = 2;
	UCSRB |= (1<<UDRIE);
}

ISR(USART_UDRE_vect){
	if(size > 0){
		UDR = tx_buffer[size-1];
		size--;
	}
	if(size == 0){
		UCSRB &= ~(1<<UDRIE);
	}
}
