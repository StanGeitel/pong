#ifndef UART_H_
#define UART_H_
#include <stdint.h>

#define BAUD		19200
#define MYUBBR		((F_CPU/(BAUD*16L))-1)			//16L is for asynchrone mode
#define BUFFER_SIZE 5

typedef struct{
	volatile static uint8_t tx_head = 0;
	volatile static uint8_t tx_tail = 0;
	volatile static uint8_t tx_tele[BUFFER_SIZE] = {0x00, 0xFF, 0xFF, 0xFF, 0xFF};
	volatile static uint8_t tx_buffer[BUFFER_SIZE];
	volatile static uint8_t ovf_counter = 0;
} Uart;

void uart_init(void);
void uart_set_pos(int16_t, int16_t);
void uart_set_button(uint8_t);
void uart_putc(uint8_t);
#endif