#ifndef UART_H_
#define UART_H_
#include <stdint.h>

#define F_CPU		8000000UL		//8MHz
#define BAUD		19200			//9600//14400//38400
#define MYUBBR		((F_CPU/(BAUD*16L))-1)			//16L is for asynchrone mode
#define X_L			0
#define X_H			1
#define Y_L			2
#define Y_H			3
#define BUTTONS		4
#define TELE_SIZE	5
#define BUFFER_SIZE 20

void uart_init(void);
void uart_set_pos(int16_t, int16_t);
void uart_set_button(uint8_t);
#endif