//UART 0

#define PINSEL0		(* (unsigned int* )(0x4002C000))	//8.5.1 Pin function select register 0
#define PCLKSEL0 	(* (unsigned int* )(0x400FC1A8))	//4.7.3 Peripheral Clock Selection register 0

#define LCR0		(* (unsigned int *)(0x4000C00C))	//14.4.7 UART Line Control Register
#define RBR0		(* (unsigned int *)(0x4000C000))	//14.4.1 UART Receiver Buffer Register
#define FCR0		(* (unsigned int *)(0x4000C008))	//14.4.6 UART FIFO Control Register
#define DLL0		(* (unsigned int *)(0x4000C000))	//14.4.3 UART Divisor Latch LSB Register
#define DLM0		(* (unsigned int *)(0x4000C004))	//14.4.3 UART Divisor Latch MSB Register


void UART_Init()
{
	PINSEL0 &= ~(0xF << 4);
	PINSEL0 |=  (0x1 << 6);			// pin P0.3 als RXD0

	FCR0 &= ~(0x7<<0);
	FCR0 |= (0x3<<0); // Enable FIFO and reset Rx FIFO buffers

	LCR0 &= ~(0xFF<<0);
	LCR0 |= (0x9B<<0); // 8bit data, 1Stop bit, Even parity, Enable access to Divisor Latches -- 10011011





}




