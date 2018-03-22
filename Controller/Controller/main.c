#define F_CPU		1000000UL		//1MHz 
#include <avr/io.h>
#include <stdint.h>
#include <util/delay.h>
#include "i2c.h"
#include "acc.h"

int main(void)
{

	
	i2c_init();
	_delay_ms(2000);
	i2c_transfer();
	
	
    while (1) 
    {
		
    }
}
