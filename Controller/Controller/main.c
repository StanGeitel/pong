#define F_CPU		8000000UL		//8MHz 
#include <avr/io.h>
#include <stdint.h>
#include <util/delay.h>

#include "i2c.h"
#include "acc.h"
#include "usart.h"
#include "timer.h"


int main(void)
{
	CLKPR = (1<<CLKPCE);		//enable clock divider changes
	CLKPR = (0<<CLKPCE)|(0<<CLKPS3)|(0<<CLKPS2)|(0<<CLKPS1)|(0<<CLKPS0);	//set clock divider to 1, 8MHz system clock
	
	//acc_init();
	//_delay_ms(3000);
	init_uart();
	uart_transmit(0x02);
    while (1) 
    {
		
		
		//acc_single_read(0x3C);
		//_delay_us(200);
    }
}
