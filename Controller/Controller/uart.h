#ifndef UART_H_
#define UART_H_
#include <stdint.h>

#define BAUD		9600
#define MYUBBR		((F_CPU/(BAUD*16L))-1)			//16L is for asynchrone mode
#define BUFFER_SIZE 16

#endif

void uart_init(void);
void uart_put_com(uint8_t, uint8_t);
void uart_putc(uint8_t);