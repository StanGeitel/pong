#include <avr/io.h>
#include <avr/interrupt.h>

#include "uart.h"

volatile static uint8_t tx_head = 0;
volatile static uint8_t tx_tail = 0;
volatile static uint8_t tx_tele[TELE_SIZE] = {0x00, 0x00, 0x00, 0x00, 0x00};
volatile static uint8_t tx_buffer[BUFFER_SIZE];

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

void uart_set_pos(int16_t xpos, int16_t ypos){
	tx_tele[X_L] = (xpos&0xFF);			//x_pos_LSB
	tx_tele[X_H] = (xpos>>8);			//x_pos_MSB
	tx_tele[Y_L] = (ypos&0xFF);			//y_pos_LSB
	tx_tele[Y_H] = (ypos>>8);			//y_pos_MSB
}

void uart_set_button(uint8_t button){
	tx_tele[BUTTONS] = (1<<button);		//set one button as pressed
}

void uart_putc(uint8_t c) {
	uint8_t tmp_head = (tx_head + 1) % BUFFER_SIZE;
	while (tmp_head == tx_tail);
	tx_buffer[tx_head] = c;
	tx_head = tmp_head;
	UCSRB |= (1<<UDRIE);
}

ISR(TIMER1_COMPA_vect){
	uart_putc(tx_tele[X_L]);
	uart_putc(tx_tele[X_H]);
	uart_putc(tx_tele[Y_L]);
	uart_putc(tx_tele[Y_H]);
	uart_putc(tx_tele[BUTTONS]);
	
	tx_tele[0] = 0x00;				//reset telegram
	tx_tele[1] = 0x00;
	tx_tele[2] = 0x00;
	tx_tele[3] = 0x00;
	tx_tele[4] = 0x00;
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