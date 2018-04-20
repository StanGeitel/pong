/*
 * SPI.c
 *
 * Created: 18-4-2018 16:30:40
 *  Author: Sven
 */ 
//#include "spi.h"
#include "spi_master.h"

#define SPI_clk_speed		4000000UL

void SPI_init(void){
	PIOA
	SPI SPI_MR = SPI_MR_MSTR;		//Set SPI in Master mode
	SPI SPI_CR = SPI_CR_SPIEN;		//Enables the SPI to transfer and receive data
	
	SPI SPI_MR = SPI_MR_PCS(xxx0);	//Peripheral Chip Select NPCS[3:0] = 1110
	
	
	
	
}




void LocalLoopbackEnable(int enable){	//LLB controls the local loopback on the data shift register for testing
	if(enable == 1){
		SPI SPI_MR = SPI_MR_LLB;		//MISO is internally connected on MOSI
	}else{
		SPI SPI_MR = ~SPI_MR_LLB;
	}
}