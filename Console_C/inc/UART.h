/*
 * UART.h
 *
 *  Created on: 5 apr. 2018
 *      Author: Sven
 */

#ifndef UART_H_
#define UART_H_


#define PINSEL0		(* (unsigned int* )(0x4002C000))	//8.5.1 Pin function select register 0
#define PINSEL1		(* (unsigned int* )(0x4002C004))
#define PCLKSEL0 	(* (unsigned int* )(0x400FC1A8))	//4.7.3 Peripheral Clock Selection register 0

#define THR1		(* (unsigned int *)(0x40010000))	//15.4.2 Transmit Holding Register
#define LCR1		(* (unsigned int *)(0x4001000C))	//15.4.7 UART Line Control Register
#define LSR1		(* (unsigned int *)(0x40010014))	//15.4.10 UART Line Status Register
#define RBR1		(* (unsigned int *)(0x40010000))	//15.4.1 UART Receiver Buffer Register
#define FCR1		(* (unsigned int *)(0x4001C008))	//15.4.6 UART FIFO Control Register

#define DLL1		(* (unsigned int *)(0x40010000))	//15.4.3 UART Divisor Latch LSB Register
#define DLM1		(* (unsigned int *)(0x40010004))	//15.4.3 UART Divisor Latch MSB Register

#define FDR1		(* (unsigned int *)(0x40010028))	//15.4.16 UART Fractional Divider Register

#define IER1		(* (unsigned int *)(0x40010004))	//15.4.4 UART Interrupt Enable Register
#define IIR1		(* (unsigned int *)(0x40010008))	//15.4.5 UART Interrupt Identification Register


#define clockCoreFreq (3000000UL)
#define pClock (1000000)

#define baudrate 4800
#endif /* UART_H_ */

void UART_Init(void);
void uart_TxChar(unsigned char ch);
unsigned char uart_RxChar();
void UART1_IRQHandler(void);
