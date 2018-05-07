/*
 * SPI.c
 *
 * Created: 18-4-2018 16:30:40
 *  Author: Sven
 */ 

//#include "stdint.h"
#include "spi.h"

void SPI_init(void){
	REG_PIOA_PDR |= (0x3 << 13);			//Disables the PIO from controlling the corresponding pin (enables peripheral control of the pin).
											//Enables peripheral control on pins PA13 & PA14, MOSI & SPCK on PIOA
	REG_PIOA_OER |= (0x3 << 13);			//Enables the output on the I/O line.
	
	
	REG_SPI_CR |= (0x1 << 0);		//Enables the SPI to transfer and receive data
	REG_SPI_MR |= (0x1 << 0);		//Set SPI in Master mode
	
	REG_SPI_MR &= ~(0x1 << 16);
	REG_SPI_MR |= (0xE << 16);		//Peripheral Chip Select NPCS[3:0] = 1110
		
}

void SPI_Send(uint8_t data){
	REG_SPI_TDR |= data;
}




void LocalLoopbackEnable(int enable){	//LLB controls the local loopback on the data shift register for testing
	if(enable == 1){
//		REG_SPI_MR |= (0x1 << 7);		//MISO is internally connected on MOSI
	}else{
//		REG_SPI_MR &= ~(0x1 << 7);
	}
}