#define F_CPU		8000000UL		//8MHz 
#include <avr/io.h>
#include <avr/interrupt.h>

#include "uart.h"

volatile static uint8_t tx_buffer[BUFFER_SIZE];
volatile static uint8_t tx_head = 0;
volatile static uint8_t tx_tail = 0;

void uart_init(void) {
	UBRRH = (uint8_t)(MYUBBR>>8);								//set baud rate
	UBRRL = (uint8_t)(MYUBBR);
	UCSRB = (1<<TXEN);											//enable transmit
	UCSRC = (1<<UPM1)|(0<<USBS)|(1<<UCSZ1)|(1<<UCSZ0);			//enable even parity, set 8-bit character, set 1 stop bit
	SREG |= (1<<SREG_I);										//enable interrupts I in global status register
}

void uart_put_com(uint8_t command, uint8_t data){
	uart_putc(command);
	uart_putc(data);
}

void uart_putc(uint8_t c){
	uint8_t tmp_head = (tx_head + 1) % BUFFER_SIZE;
	while(tmp_head == tx_tail);
	tx_buffer[tx_head] = c;
	tx_head = tmp_head;
	UCSRB |= (1<<UDRIE);
}

ISR(USART_UDRE_vect){
	uint8_t tmp_tail = 0;
	if(tx_tail != tx_head){
		tmp_tail = (tx_tail + 1) % BUFFER_SIZE;
		UDR = tx_buffer[tx_tail];
		tx_tail = tmp_tail;
	}else{
		UCSRB &= ~(1<<UDRIE);
	}
}
