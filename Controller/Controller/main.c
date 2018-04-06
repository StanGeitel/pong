#define F_CPU		8000000UL		//8MHz 
#include <avr/io.h>
#include <stdint.h>
#include <util/delay.h>

#include "acc.h"
#include "usart.h"
#include "gauge.h"
#include "gpio.h"

int main(void)
{
	CLKPR = (1<<CLKPCE);		//enable clock divider changes
	CLKPR = (0<<CLKPCE)|(0<<CLKPS3)|(0<<CLKPS2)|(0<<CLKPS1)|(0<<CLKPS0);	//set clock divider to 1, 8MHz system clock
	
/*	acc_init();
	_delay_ms(3000);
	acc_burst_read(X_MSB);
*/
	uart_init();
//	_delay_ms(3000);
//	uart_transmit(0x55);
	uart_put_com(0x55, 0x55);
	
	
//	acc_init();
//	uart_init();
//	gauge_init();
//	gpio_init();
	
    while (1) 
    {
    }
}
