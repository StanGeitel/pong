#ifndef USART_H_
#define USART_H_

#include <stdio.h>
#include <util/delay.h>

#define BAUD		9600
#define MYUBBR		((F_CPU/(BAUD*16L))-1)			//16L is for asynchrone mode


#endif /* USART_H_ */


// Initialize UART to 9600 baud with 8N1.
void init_uart(void);
void uart_transmit(uint8_t command, uint8_t data);
