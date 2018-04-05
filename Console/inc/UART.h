/*
 * UART.h
 *
 *  Created on: 5 apr. 2018
 *      Author: Sven
 */

#ifndef UART_H_
#define UART_H_

#define PINSEL0		(* (unsigned int* )(0x4002C000))	//8.5.1 Pin function select register 0
#define PCLKSEL0 	(* (unsigned int* )(0x400FC1A8))	//4.7.3 Peripheral Clock Selection register 0

#define LCR0		(* (unsigned int *)(0x4000C00C))	//14.4.7 UART Line Control Register
#define LSR0		(* (unsigned int *)(0x4000C014))	//14.4.8 UART Line Status Register
#define RBR0		(* (unsigned int *)(0x4000C000))	//14.4.1 UART Receiver Buffer Register
#define FCR0		(* (unsigned int *)(0x4000C008))	//14.4.6 UART FIFO Control Register
#define DLL0		(* (unsigned int *)(0x4000C000))	//14.4.3 UART Divisor Latch LSB Register
#define DLM0		(* (unsigned int *)(0x4000C004))	//14.4.3 UART Divisor Latch MSB Register

#define clockCoreFreq (12000000UL)

void UART_Init(void);
char uart_RxChar();

#endif /* UART_H_ */
