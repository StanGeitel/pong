#define F_CPU		8000000UL		//8MHz 
#include <avr/io.h>
#include <stdint.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#include "usart.h"
#include "gpio.h"
#include "i2c.h"
#include "acc.h"
#include "gauge.h"

int main(void)
{
	CLKPR = (1<<CLKPCE);		//enable clock divider changes
	CLKPR = (0<<CLKPCE)|(0<<CLKPS3)|(0<<CLKPS2)|(0<<CLKPS1)|(0<<CLKPS0);	//set clock divider to 1, 8MHz system clock
	
	gpio_init();
	gauge_init();
	
//	uart_init();
//	acc_init();
    while (1) 
    {
    }
}
