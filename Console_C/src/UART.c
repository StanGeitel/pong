/*
 * UART.c
 *
 *  Created on: 5 apr. 2018
 *      Author: Sven
 */

#define PINSEL0		(* (unsigned int* )(0x4002C000))	//8.5.1 Pin function select register 0
#define PCLKSEL0 	(* (unsigned int* )(0x400FC1A8))	//4.7.3 Peripheral Clock Selection register 0

#define LCR0		(* (unsigned int *)(0x4000C00C))	//14.4.7 UART Line Control Register
#define LSR0		(* (unsigned int *)(0x4000C014))	//14.4.8 UART Line Status Register
#define RBR0		(* (unsigned int *)(0x4000C000))	//14.4.1 UART Receiver Buffer Register
#define FCR0		(* (unsigned int *)(0x4000C008))	//14.4.6 UART FIFO Control Register
#define DLL0		(* (unsigned int *)(0x4000C000))	//14.4.3 UART Divisor Latch LSB Register
#define DLM0		(* (unsigned int *)(0x4000C004))	//14.4.3 UART Divisor Latch MSB Register

#define clockCoreFreq (12000000UL)

#include "UART.h"
#include "stdutils.h"

void UART_Init(void)
{
	uint32_t UartPclk, Pclk, RegValue;

	PINSEL0 &= ~(0xF << 4);
	PINSEL0 |=  (0x1 << 6);			// pin P0.3 als RXD0

	FCR0 &= ~(0x7<<0);
	FCR0 |= (0x3<<0); // Enable FIFO and reset Rx FIFO buffers

	LCR0 &= ~(0xFF<<0);
	LCR0 |= (0x9B<<0); // 8bit data, 1Stop bit, Even parity, Enable access to Divisor Latches -- 10011011


	/** Baud Rate Calculation :
	   PCLKSELx registers contains the PCLK info for all the clock dependent peripherals.
	   Bit6,Bit7 contains the Uart Clock(ie.UART_PCLK) information.
	   The UART_PCLK and the actual Peripheral Clock(PCLK) is calculated as below.
	   (Refer data sheet for more info)

	   UART_PCLK    PCLK
		 0x00       SystemFreq/4
		 0x01       SystemFreq
		 0x02       SystemFreq/2
		 0x03       SystemFreq/8
	 **/

	UartPclk = (PCLKSEL0 >> 6) & 0x03;

	switch( UartPclk )
	{
		  case 0x00:
			Pclk = clockCoreFreq/4;
			break;
		  case 0x01:
			Pclk = clockCoreFreq;
			break;
		  case 0x02:
			Pclk = clockCoreFreq/2;
			break;
		  case 0x03:
			Pclk = clockCoreFreq/8;
			break;
	}

	RegValue = ( Pclk / (16 * 9600 )); //9600 baud rate
	DLL0 =  RegValue & 0xFF;
	DLM0 = (RegValue >> 0x08) & 0xFF;

	LCR0 &= ~(0x1<<7);  // Clear DLAB after setting DLL,DLM
}

char uart_RxChar()
{
    char ch;
    while( LSR0 == (0x1 << 0));  // Wait till the data is received
    ch = RBR0;               	// Read received data
    return ch;
}





