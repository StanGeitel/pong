/*
 * Console_cpp.cpp
 *
 * Created: 16/05/2018 17:56:01
 * Author : stan
 */ 


#include "sam.h"
#include "sam4s8b.h"
#include "spi.h"
#include "usart.h"

int main(void)
{
    /* Initialize the SAM system */
    SystemInit();
	
	while(!(REG_PMC_SR & PMC_SR_MOSCRCS));
	REG_CKGR_MOR |= CKGR_MOR_KEY_PASSWD | CKGR_MOR_MOSCRCF_12_MHz;
	while(!(REG_PMC_SR & PMC_SR_MCKRDY));
	REG_CKGR_PLLAR |= CKGR_PLLAR_DIVA(1);
	REG_CKGR_PLLAR |= CKGR_PLLAR_MULA(9);
	while(!(REG_PMC_SR & PMC_SR_LOCKA));
	REG_PMC_MCKR |= PMC_MCKR_PRES_CLK_1;
	while(!(REG_PMC_SR & PMC_SR_MCKRDY));
	REG_PMC_MCKR |= PMC_MCKR_CSS_PLLA_CLK;
	while(!(REG_PMC_SR & PMC_SR_MCKRDY));
	

    while (1) 
    {
    }
}
