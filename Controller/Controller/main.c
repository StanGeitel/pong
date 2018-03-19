#include <avr/io.h>
#include <stdint.h>

#include "i2c.h"
#include "acc.h"

int main(void)
{
 //   i2c_init();
 	DDRB = (1 << PINB5) | (1 << PINB7);		//enable output driver for SDA and SCL.
	PORTB = (1 << PINB5) | (1 << PINB7);	//set HIGH with pull up.


//	PORTB &= ~(1<<PINB5);
//	PORTB &= ~(1<<PINB7);
	
    while (1) 
    {
    }
}

