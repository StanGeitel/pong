#ifndef UART_H_
#define UART_H_
#include <stdint.h>

#define BAUD		4800
#define MYUBBR		((F_CPU/(BAUD*16L))-1)			//16L is for asynchrone mode

#endif

void uart_init(void);
void uart_transmit(uint8_t);
void uart_put_com(uint8_t, uint8_t);