/*
 * UART.h
 *
 *  Created on: 5 apr. 2018
 *      Author: Sven
 */

#ifndef UART_H_
#define UART_H_
#include "stdutils.h"

void UART_Init(uint32_t baudrate);
int uart_RxChar();

#endif /* UART_H_ */
