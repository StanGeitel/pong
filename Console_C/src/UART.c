
#include <stdio.h>
#include "UART.h"
#include "stdutils.h"

void UART1_IRQHandler(void){
	uint32_t tmp;
	unsigned char ch;
	tmp |= (IIR1 & 0xE) ;

	// Receive Data Available
	if ((tmp == 0x4) || (tmp == 0xC))
	{
		ch = uart_RxChar();
		printf("%x \n", ch);
	}
}

void UART_Init(void)
{
	uint32_t Fdiv;

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

	Fdiv = ( pClock / (16 * baudrate ));
	DLL1 =  Fdiv & 0xFF;
	DLM1 = (Fdiv >> 0x08) & 0xFF;

	//-------------------------------------------------------
	LCR1 &= ~(0x1<<7);  	// Clear DLAB after setting DLL,DLM

	IER1 |= (0x5<<0);			//Enable the RDA interrupts.
	//IIR1 |= ()
}

void uart_TxChar(unsigned char ch)
{
    while( !(LSR1 & ( 1 << 5)) ); 			// Wait for Previous transmission
    THR1=ch;                                // Load the data to be transmitted
}

unsigned char uart_RxChar()
{
	unsigned char ch;
    while( !(LSR1 & (1 << 0)) ); 			//wait until any data arrives in Rx FIFO
    ch = RBR1 & (0xFF << 0); 				// Read received data
    return ch;
}





