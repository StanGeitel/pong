#define F_CPU		8000000UL		//8MHz 
#include <avr/io.h>
#include <stdint.h>
#include <util/delay.h>

#include "i2c.h"
#include "acc.h"
#include "usart.h"


int main(void)
{
	CLKPR = (1<<CLKPCE);		//enable clock divider changes
	CLKPR = (0<<CLKPCE)|(0<<CLKPS3)|(0<<CLKPS2)|(0<<CLKPS1)|(0<<CLKPS0);	//set clock divider to 1, 8MHz system clock
	
	_delay_ms(3000);
	i2c_init();
	i2c_send_start();
	i2c_send_data(0x25);
	i2c_get_ack();
	i2c_send_stop();

    while (1) 
    {
    }
}
