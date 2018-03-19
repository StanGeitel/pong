#include <avr/io.h>
#include <stdint.h>

#include "i2c.h"
#include "acc.h"

int main(void)
{
	i2c_init();
	i2c_send_stop();
	
    while (1) 
    {
    }
}
