
#ifndef GPIO_H_
#define GPIO_H_
#include <stdint.h>

#define _PORT	0xB
#define B0		0
#define B1		1
#define B2		2
#define B3		3
#define L0		5

#define B0_COM		0b010
#define B1_COM		0b011
#define B2_COM		0b100

#define PIN(_PORT) _SFR_IO8(0x019-((_PORT-10)*3))
#define DDR(_PORT) _SFR_IO8(0x01A-((_PORT-10)*3))
#define PORT(_PORT) _SFR_IO8(0x01B-((_PORT-10)*3))

#endif

void gpio_init(void);
void gpio_set_led(void);
void gpio_reset_led(void);
