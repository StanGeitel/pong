
#include <stdio.h>
#include "UART.h"
#include "stdutils.h"

int g = 0;
double a = 0;
int count = 0;

void UART1_IRQHandler(void){
	if(count  == 0){
		g |= (uart_RxChar()<<8);
		printf("%d  %x  1\n", g, g);
		count++;
	}
	else if(count == 1){
		g |= uart_RxChar();
		printf("%d  %x   2\n", g, g);
		count++;
	}
	if(count == 2){
		double temp = (double)g;
		a = ((temp/16384)*9.81);
		printf("%lf    3\n", a);
		count = 0;
		a = 0;
		g = 0;
	}
}

void UART_Init(void)
{
	uint32_t Fdiv;

	ISER0 |= (0x1 << 6);

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

	IER1 |= (0x1<<0);			//Enable the RDA interrupts.
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

void acceleratie(unsigned char ch){
	unsigned char acceleratie;

}





