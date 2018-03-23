#define F_CPU		1000000UL		//1MHz 
#include <avr/io.h>
#include <avr/common.h>
#include <avr/interrupt.h>
#include <stdint.h>
#include <util/delay.h>

#include "usart.h"

volatile static uint8_t tx_buffer[2];
volatile static uint8_t bytes = 2;

void init_uart(void) {
  UBRRH = (uint8_t)(MYUBBR >> 8);	//set baud rate
  UBRRL = (uint8_t)(MYUBBR);
  UCSRB = (1 << TXEN);				//enable transmit
  UCSRC = (1<<UPM1) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0);		//enable even parity, set 8-bit character, set 1 stop bit
}

void uart_transmit(uint8_t command, uint8_t data) {
  while (!(UCSRA & (1<<UDRE)));
  tx_buffer[0] = command;
  tx_buffer[1] = data;
  UCSRB |= (1<<UDRIE);					// enable uart data interrupt (send data)
}

//send a command out of the buffer
ISR(USART_UDRE_vect) {
	if(bytes > 0){
		UDR = tx_buffer[bytes];			//write byte to data register
		bytes--;						//lower bytes by one
	}else{
		UCSRB &= ~(1<<UDRIE);			//disable interrupt
	}
}
