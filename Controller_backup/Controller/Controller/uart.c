#define F_CPU		8000000UL		//8MHz 
#include <avr/io.h>
#include <avr/interrupt.h>

#include "uart.h"

void uart_init(void) {
	UBRRH = (uint8_t)(MYUBBR>>8);								//set baud rate
	UBRRL = (uint8_t)(MYUBBR);
	UCSRB = (1<<TXEN);											//enable transmit
	UCSRC = (0<<USBS)|(1<<UCSZ1)|(1<<UCSZ0);					//set 8-bit character, set 1 stop bit
	
	TCCR1A = (0<<COM1A1)|(0<<COM1A0)|(0<<COM1B1)|(0<<COM1B0)|(0<<WGM11)|(0<<WGM10);
	TCCR1B = (0<<ICNC1)|(0<<ICES1)|(0<<WGM13)|(1<<WGM12)|(0<<CS12)|(1<<CS11)|(0<<CS10);		//8MHz with 8 prescaler, clear timer on compare results in 1MHz counter
	TIMSK |= (1<<OCIE1A);										//enable output compare A match interrupt
	OCR1AH = 0x27;												//compare on 10000 clock cycles resulting in 10 milliseconds
	OCR1AL = 0x10;												
	SREG |= (1<<SREG_I);										//enable interrupts I in global status register
}

void uart_set_pos(Uart *uart, int16_t xpos, int16_t ypos){
	(*uart).tx_tele[0] = (xpos&0xFF);		//x_pos_LSB
	(*uart).tx_tele[1] = (xpos>>8);			//x_pos_MSB
	(*uart).tx_tele[2] = (ypos&0xFF);		//y_pos_LSB
	(*uart).tx_tele[3] = (ypos>>8);			//y_pos_MSB
}

void uart_set_button(Uart *uart, uint8_t button){
	(*uart).tx_tele[4] = (1<<button);		//set one button as pressed
}

void uart_putc(Uart *uart, uint8_t c){
	uint8_t (*uart).tmp_head = ((*uart).tx_head + 1) % BUFFER_SIZE;
	while((*uart).tmp_head == (*uart).tx_tail);
	(*uart).tx_buffer[tx_head] = c;
	(*uart).tx_head = (*uart).tmp_head;
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

ISR(TIMER1_COMPA_vect){
	for(uint8_t i = 0; i < BUFFER_SIZE; i++){
		uart_putc(tx_tele[i]);		//put telegram in UART-buffer
	}
	tx_tele[0] = 0x00;				//reset telegram
	tx_tele[1] = 0xFF;
	tx_tele[2] = 0xFF;
	tx_tele[3] = 0xFF;
	tx_tele[4] = 0xFF;
}
