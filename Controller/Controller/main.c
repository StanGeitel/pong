#include <avr/io.h>
#include <stdint.h>

#include "i2c.h"
#include "acc.h"

int main(void)
{
	init();
	send_start();


//	PORTB &= ~(1<<PINB5);
//	PORTB &= ~(1<<PINB7);
	
    while (1) 
    {
    }
}

