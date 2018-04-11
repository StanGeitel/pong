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
	unsigned char ch;

	//PINSEL3 |= (0x1 << 22);
	//CLKOUTCFG |= (0x0 << 0);
	//CLKOUTCFG |= (0x1 << 8);
    printf("Start\n");
    UART_Init();
    //uart_TxChar(0x11);

    //ch = uart_RxChar();
    //printf(ch);

    // Force the counter to be placed into memory
    volatile static int i = 0 ;
    // Enter an infinite loop, just incrementing a counter
    while(1) {
    	//uart_TxChar(0xD7);

    	//ch = uart_RxChar();
    	//printf("%x \n", ch);
    	//ch++;

    	//for(int x =0; x < 100000; x++);
    	//printf("- \n");
    	//uart_TxChar(ch);
        i++ ;
    }
    return 0 ;
}
