/*
 * UART.h
 *
 *  Created on: 5 apr. 2018
 *      Author: Sven
 */

#ifndef UART_H_
#define UART_H_

void UART_Init(void);
void uart_TxChar(unsigned char ch);
unsigned char uart_RxChar();

#endif /* UART_H_ */
