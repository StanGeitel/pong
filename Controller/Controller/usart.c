#define F_CPU		8000000UL		//8MHz 
#include <avr/io.h>
#include <avr/interrupt.h>

#include "usart.h"

void init_uart(void) {
  UBRRH = (uint8_t)(MYUBBR >> 8);								//set baud rate
  UBRRL = (uint8_t)(MYUBBR);
  UCSRB = (1 << TXEN);											//enable transmit
  UCSRC = (1<<UPM1) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0);		//enable even parity, set 8-bit character, set 1 stop bit
}

void uart_transmit(uint8_t command) { //, uint8_t data
  while (!(UCSRA & (1<<UDRE)));
  UDR = command;
  //while (!(UCSRA & (1<<UDRE)));
  //UDR = data; 
}
