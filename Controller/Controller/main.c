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
	
	TCCR0A = (0<<COM0A1)|(0<<COM0A0)|(0<<COM0B1)|(0<<COM0B0)|(0<<WGM01)|(0<<WGM00);
	TCCR0B = (0<<FOC0A)|(0<<FOC0B)|(0<<WGM02)|(0<<CS02)|(0<<CS01)|(0<<CS00);
	//8MHz / 1024 = 7812,5Hz een overflow is 30ms, 17 * 30 = 500ms
	TIMSK |= (1<<TOIE0);	//enable interrupt on overflow 8-bit
	SREG |= (1<<SREG_I);	//enable interrupts I in global status register
	
	TCNT0 = 0x00;
	TCCR0B |= (1<<CS02)|(1<<CS00); // 101 is prescaler van 1024

//	uart_init();
//	gauge_init();
//	acc_init();
    while (1) 
    {
    }
}
