#ifndef UART_H_
#define UART_H_
#include <stdint.h>

#define BAUD		19200
#define MYUBBR		((F_CPU/(BAUD*16L))-1)			//16L is for asynchrone mode
#define BUFFER_SIZE 5

#endif

void uart_init(void);
void uart_set_pos(int16_t, int16_t);
void uart_set_button(uint8_t);
void uart_putc(uint8_t);