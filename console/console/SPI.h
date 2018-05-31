/*
 * SPI.h
 *
 * Created: 20-4-2018 14:17:41
 *  Author: Sven
 */ 


#ifndef SPI_H_
#define SPI_H_
#include "sam4s8b.h"

#define SPI_clk_speed		4000000UL

void SPI_init(void);
void SPI_Send(uint16_t data);
void LocalLoopbackEnable(int enable);



#endif /* SPI_H_ */