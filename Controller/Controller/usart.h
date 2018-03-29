#ifndef USART_H_
#define USART_H_
#include <stdint.h>

#define BAUD		9600
#define MYUBBR		((F_CPU/(BAUD*16L))-1)			//16L is for asynchrone mode

#endif /* USART_H_ */

void init_uart(void);
void uart_transmit(uint8_t, uint8_t );
