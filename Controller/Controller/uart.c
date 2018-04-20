#define F_CPU		8000000UL		//8MHz 
#include <avr/io.h>
#include <avr/interrupt.h>

#include "uart.h"

volatile static uint8_t tx_buffer[BUFFER_SIZE];
volatile static uint8_t tx_head = 0;
volatile static uint8_t tx_tail = 0;

volatile static uint8_t tx_tele[5] = {0x00, 0xFF, 0xFF, 0xFF, 0xFF};

void uart_init(void) {
	UBRRH = (uint8_t)(MYUBBR>>8);								//set baud rate
	UBRRL = (uint8_t)(MYUBBR);
	UCSRB = (1<<TXEN);											//enable transmit
	UCSRC = (0<<USBS)|(1<<UCSZ1)|(1<<UCSZ0);					//set 8-bit character, set 1 stop bit
	SREG |= (1<<SREG_I);										//enable interrupts I in global status register
}

void uart_set_pos(uint16_t xpos, uint16_t ypos){
	tx_tele[0] = (xpos&0xFF);
	tx_tele[1] = (xpos>>8);
	tx_tele[2] = (ypos&0xFF);
	tx_tele[3] = (ypos>>8);
}

void uart_set_button(uint8_t button){
	tx_tele[4] = (1<<button);
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
