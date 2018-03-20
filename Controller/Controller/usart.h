#ifndef USART_H_
#define USART_H_

#include <stdio.h>
#include <util/delay.h>



#endif /* USART_H_ */


// Initialize UART to 9600 baud with 8N1.
void init_uart(void);
void send_uart(uint8_t c);
uint8_t uart_getc_wait(void);
int uart_getc_f(FILE *stream);
