/*
===============================================================================
 Name        : main.c
 Author      : $(author)
 Version     :
 Copyright   : $(copyright)
 Description : main definition
===============================================================================
*/

#ifdef __USE_CMSIS
#include "LPC17xx.h"
#endif

#include <cr_section_macros.h>

#ifdef __cplusplus
extern "C"
{
#endif

#include "UART.h"

#ifdef __cplusplus
}
#endif
// TODO: insert other include files here
#include <stdio.h>
// TODO: insert other definitions and declarations here



int main(void) {
	char uart_rec;
    // TODO: insert code here
	extern "C" void UART_Init(void);
	printf("Initialized. Application started.\n");
	uart_rec extern "C" char uart_RxChar();

    // Force the counter to be placed into memory
    volatile static int i = 0 ;
    // Enter an infinite loop, just incrementing a counter
    while(1) {
        i++ ;
    }
    return 0 ;
}
