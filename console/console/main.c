#include "sam4s8b.h"
#include "spi.h"

int main(void)
{
    /* Initialize the SAM system */
    SystemInit();
	
	//REG_PIOA_PER |= (0xF << 4);		//Enables the PIO to control the corresponding pin (disables peripheral control of the pin).
	//REG_PIOA_OER |= (0xF << 4);		//Enables the output on the I/O line
	//REG_PIOA_ODR |= (0xF << 4);
	
	SPI_init();
	SPI_Send(0xFF);
	
    while (1) 
    {
		//REG_PIOA_SODR |= (0xF << 4);
		//for (int x = 0; x < 10000; x++);
		//REG_PIOA_CODR |= (0xF << 4);
    }
}

