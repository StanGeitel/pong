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
#include "stdutils.h"
// TODO: insert other definitions and declarations here

int main(void) {
	int ch;

    printf("Start\n");
    UART_Init();

    // Force the counter to be placed into memory
    volatile static int i = 0 ;
    // Enter an infinite loop, just incrementing a counter
    while(1) {

    	ch = uart_RxChar();
    	printf(ch);
    	printf("- \n");
        i++ ;
    }
    return 0 ;
}
