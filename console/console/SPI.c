/*
 * SPI.c
 *
 * Created: 18-4-2018 16:30:40
 *  Author: Sven
 */ 

//#include "stdint.h"
#include "spi.h"

#define spi_id 21	// SPI Peripheral Identifier 21

void SPI_init(void){
	 
	 //enable peripheral clock
	 REG_PMC_PCER0 |= (0x1 << spi_id);
	 //set spi master mode
	 REG_SPI_MR |= (0x1 << 0);

	 //set polarity and clock phase
	 REG_SPI_CSR &= ~(0x1 << 0); //The inactive state value of SPCK is logic level zero
	 REG_SPI_CSR |= (0x1 << 1); //Data is captured on the leading edge of SPCK and changed on the following edge of SPCK.
	 
	 //set clock generator to peripheral clock rate, SCBR = fperipheral clock / SPCK Bit Rate
	 REG_SPI_CSR |= SPI_CSR_SCBR(1);
	 
	 //give peripheral control of pins
	 REG_PIOA_PDR |= PIO_PDR_P13; //MOSI
	 REG_PIOA_PDR |= PIO_PDR_P14; //SPCK
	 //enable SPI
	 REG_SPI_CR |= SPI_CR_SPIEN;
}

<<<<<<< HEAD
void SPI_Send(uint16_t data){
	//wait for transmit register to be empty
	while (!(REG_SPI_SR & SPI_SR_TDRE));
	//send data to transmit register
	REG_SPI_TDR |= data;
=======
void LocalLoopbackEnable(int enable){	//LLB controls the local loopback on the data shift register for testing
	if(enable == 1){
//		REG_SPI_MR |= (0x1 << 7);		//MISO is internally connected on MOSI
	}else{
//		REG_SPI_MR &= ~(0x1 << 7);
	}
>>>>>>> 29987dacf30faabcb92c71c3bf118d9604c7c403
}