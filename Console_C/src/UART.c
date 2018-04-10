
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

#define IER1		(* (unsigned int *)(0x4001C004))	//15.4.4 UART Interrupt Enable Register

#define clockCoreFreq (1100000UL)
#define pClock (1000000)

#define baudrate 9600

#include "UART.h"
#include "stdutils.h"

void UART_Init(void)
{
	uint32_t UartPclk, Pclk, Fdiv;

	PINSEL0 &= ~(0x3 << 30);
	PINSEL0 |=  (0x1 << 30);		//p0.15 als TXD1
	PINSEL1 &= ~(0x3 << 0);
	PINSEL1 |=  (0x1 << 0);			//p0.16 als RXD1


	FCR1 &= ~(0x7<<0);
	FCR1 |= (0x7<<0); 			// Enable FIFO and reset Rx FIFO buffers

	LCR1 &= ~(0xFF<<0);
	LCR1 |= (0x9B<<0); 			// 8bit data, 1Stop bit, Even parity, Enable access to Divisor Latches -- 10011011
	//-------------------------------------------------------

	//Fdiv = ( clockCoreFreq / 16 ) / baudrate ;    // Set baud rate

	//DLM1 = Fdiv / 256;
	//DLL1 = Fdiv % 256;

	Fdiv = ( pClock / (16 * 9600 ));
	DLL1 =  Fdiv & 0xFF;
	DLM1 = (Fdiv >> 0x08) & 0xFF;

	//-------------------------------------------------------
	LCR1 &= ~(0x1<<7);  	// Clear DLAB after setting DLL,DLM

	IER1 |= (0x1<<0);			//Enable the RDA interrupts.
}

void uart_TxChar(unsigned char ch)
{
    while( !(LSR1 & ( 1 << 5)) ); // Wait for Previous transmission
    THR1=ch;                                  // Load the data to be transmitted
}

unsigned char uart_RxChar()
{
	unsigned char ch;
    while( !(LSR1 & (1 << 0)) ); 			//wait until any data arrives in Rx FIFO
    ch = RBR1 & (0xFF << 0); 				// Read received data
    return ch;
}





