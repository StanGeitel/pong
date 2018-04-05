/*
===============================================================================
 Name        : Console_C.c
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

#include <stdio.h>

// TODO: insert other include files here
#include "UART.h"
// TODO: insert other definitions and declarations here

int main(void) {

    printf("Start\n");
    UART_Init();
    printf(uart_RxChar() + " -/n");

    // Force the counter to be placed into memory
    volatile static int i = 0 ;
    // Enter an infinite loop, just incrementing a counter
    while(1) {
        i++ ;
    }
    return 0 ;
}
