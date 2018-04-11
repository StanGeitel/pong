#include <avr/io.h>
#include <avr/interrupt.h>

#include "gauge.h"
#include "i2c.h"

uint8_t count = 0;

void gauge_init(void){
	i2c_init();
	i2c_burst_write(GAUGE_ADD, CHARGE_MSB, 0xFF, 0xFF);
	i2c_burst_write(GAUGE_ADD, LOW_TRE_MSB, 0x7C, 0x1C);
	
	MCUCR |= (0<<ISC10);	//The falling edge of INT1 generates an interrupt request
	MCUCR |= (1<<ISC11);
	GIMSK |= (1<<INT1);		//enable external interrupt 1 in general interrupt mask register
	
	PORTB &= ~(1<<PINB4);		//turn led on
	DDRB |= (1<<PINB4);			//set led as output
	
	TCCR0A = (0<<COM0A1)|(0<<COM0A0)|(0<<COM0B1)|(0<<COM0B0)|(0<<WGM01)|(0<<WGM00);
	TCCR0B = (0<<FOC0A)|(0<<FOC0B)|(0<<WGM02)|(0<<CS02)|(0<<CS01)|(0<<CS00);
	//8MHz / 1024 = 7812,5Hz een overflow is 30ms, 17 * 30 = 500ms
	TIMSK |= (1<<TOIE0);	//enable interrupt on overflow 8-bit
	SREG |= (1<<SREG_I);	//enable interrupts I in global status register	
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

ISR(INT1_vect){	//External interrupt1 service routine
	if((TCCR0B & (1<<CS02)) && (TCCR0B & (1<<CS00))){ // Als led is aan of knipperend , maar dat is geen 1 en 0 dus even kijken hoe detecteren
		TCCR0B &= ~((1<<CS02)|(1<<CS00)); // 000 disconnect clock
		PORTB &= ~(1<<PINB4);
		i2c_burst_write(GAUGE_ADD, HIGH_TRE_MSB, 0x00, 0x00);
		i2c_burst_write(GAUGE_ADD, LOW_TRE_MSB, 0x7C, 0x1C); // 30%
		i2c_send_arp_gauge();	
	}else{
		TCNT0 = 0x00;
		TCCR0B |= (1<<CS02)|(1<<CS00); // 101 is prescaler van 1024
		i2c_burst_write(GAUGE_ADD, LOW_TRE_MSB, 0x00, 0x00);
		i2c_burst_write(GAUGE_ADD, HIGH_TRE_MSB, 0x7D, 0xFD); // 31%
		i2c_send_arp_gauge();
	}
}

ISR(TIMER0_OVF_vect){
	if(count == 17){
		PORTB ^= (1<<PINB4);
		count = 0;
	}else{
		count++;
	}
}



