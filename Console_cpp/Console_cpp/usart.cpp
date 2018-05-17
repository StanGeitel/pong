/*
 * uart.cpp
 *
 * Created: 16/05/2018 17:57:02
 *  Author: stan
 */ 

#include "usart.h"

void usart_init(){
	REG_PIOA_ABCDSR |= PIO_ABCDSR_P5;
	
}
