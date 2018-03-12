#define F_CPU		8000000UL	//8MHz
#include <avr/io.h>
#include <stdint.h>
#include <util/delay.h>

#include "i2c.h"
#include "acc.h"



int main(void)
{
    i2c_init();
	i2c_send_start();
	
    while (1) 
    {
    }
}

