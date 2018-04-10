#include <avr/io.h>
#include <avr/interrupt.h>

#include "gauge.h"
#include "i2c.h"
#include "gpio.h"

uint8_t count = 0;

void gauge_init(void){
	i2c_init();
	i2c_burst_write(GAUGE_ADD, CHARGE_MSB, 0xFF, 0xFF);
	i2c_burst_write(GAUGE_ADD, LOW_TRE_MSB, 0x7C, 0x1C);
	PORT(_PORT) &= ~(1<<L0); // wat doet led in het begin?
		
//	i2c_single_write(GAUGE_ADD, CHARGE_MSB, 0xFF);
//	i2c_single_write(GAUGE_ADD, CHARGE_LSB, 0xFF);
//	i2c_burst_write(GAUGE_ADD, HIGH_TRE_MSB, 0xFF, 0xFF);

	MCUCR |= (0<<ISC10);	//The falling edge of INT1 generates an interrupt request
	MCUCR |= (1<<ISC11);
	GIMSK |= (1<<INT1);		//enable external interrupt 1 in general interrupt mask register
	SREG |= (1<<SREG_I);	//enable interrupts I in global status register
	
	TCCR0A = (0<<COM0A1)|(0<<COM0A0)|(0<<COM0B1)|(0<<COM0B0)|(0<<WGM01)|(0<<WGM00);
	TCCR0B = (0<<FOC0A)|(0<<FOC0B)|(0<<WGM02)(0<<CS02)|(0<<CS01)|(0<<CS00);
	OCR1AH = 0x0F;	//8MHz / 1024 = 7812,5Hz -> 500ms is dan 3906,25 stappen = 0x0F42
	OCR1AL = 0x42;
	TIMSK |= (1<<TOIE0);	//enable interrupt on overflow 8-bit
	SREG |= (1<<SREG_I);	//enable interrupts I in global status register	
}

void gauge_read_charge(){
	uint16_t buffer;
	buffer = i2c_burst_read(GAUGE_ADD, CHARGE_MSB);	
	// q(LSB) - 42,5 uAh daardoor nemen registers C en D 48235,29 stappen af in totaal (van 100-0 %)
	// 17301 is 0% en 31771,5 is 30% en 65535 is 100% // 31% is 32253,94
	if (buffer > 31772){
		PORT(_PORT) &= ~(1<<L0);
	}
	else{
		PORT(_PORT) |= (1<<L0);
	}
}

ISR(INT1_vect){	//External interrupt1 service routine
	
	if ( (TCCR0B & (1<<CS02)) && (TCCR0B & (1<<CS00)) ){ // Als led is aan of knipperend , maar dat is geen 1 en 0 dus even kijken hoe detecteren
		TCNT0 = 0x00;
		TCCR0B |= (1<<CS02)|(1<<CS00); // 101 is prescaler van 1024
		i2c_burst_write(GAUGE_ADD, LOW_TRE_MSB, 0x00, 0x00);
		i2c_burst_write(GAUGE_ADD, HIGH_TRE_MSB, 0x7D, 0xFD); // 31%
		i2c_send_arp_gauge();
	}
	else{
		TCCR0B |= (0<<CS02)|(0<<CS00); // 101 is prescaler van 1024
		i2c_burst_write(GAUGE_ADD, HIGH_TRE_MSB, 0xFF, 0xFF);
		i2c_burst_write(GAUGE_ADD, LOW_TRE_MSB, 0x7C, 0x1C); // 30%
		i2c_send_arp_gauge();		
	}
}

void i2c_send_arp_gauge(){ // naam aanpassen?
	uint8_t temp;
	i2c_send_start();
	i2c_send_data(ARA<<1);
	i2c_get_ack();						
	temp = i2c_get_data();	//fuel gauge zou reageren met zijn adress
	if (temp != GAUGE_ADD){
		// Eventueel warning naar console sturen als temp niet gelijk is aan GAUGE_ADD of nogmaals proberen
	}
	i2c_send_nack();
	i2c_send_stop();
}

ISR(TIMER0_OVF_vect){
	if (count == 17){
	PORT(_PORT) ^= (1<<L0);
	count = 0;
	}
	else{
		count++;
	}
}



