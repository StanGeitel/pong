/*
 * Berekening_MPU6050.c
 *
 * Created: 24-4-2018 21:38:58
 * Author : ikben
 */ 

#include <avr/io.h>
static float xV;
static float yV;
static float xPosNew;
static float yPosNew;
static float xPosOld;
static float yPosOld;
static int xDrift;
static int yDrift;
static int xvNeg;
static int yvNeg;
static int xvPos;
static int yvPos;
static int xvgNeg;
static int yvgNeg;
static int xvgPos;
static int yvgPos;
static float t = 0.001;
static float xAccDec;
static float yAccDec;
static float xAccRaw; //xAccRaw is de versnelling van x die gemeten wordt
static float yAccRaw; //yAccRaw is de versnelling van y die gemeten wordt


int main(void)
{
    /* Replace with your application code */
    while (1) 
    {
		xAccDec = xAccRaw * 100;
		xAccDec = round(xAccDec);
		xAccRaw = xAccDec/100;
		if(xvPos == 0 && xvNeg == 0 && (xAccRaw > 0.01 || xAccRaw < -0.01) ) //Nog finetunnen
		{
			xPosNew = xPosOld + xV * t + 0.5 * (xAccRaw * 9.81) * t * t;
			xV = xV + xAccRaw * t;
			xPosOld = xPosNew;
		}
		if(xAccRaw <= 0.01 && xAccRaw >= -0.01) //Nog finetunnen
		{
			xDrift = xDrift + 1;
		}
		
		if(xDrift == 8) //Nog finetunen
		{
			xV = 0;
			xDrift = 0;
			xvgPos = 0;
			xvgNeg = 0;
			xvNeg = 0;
			xvPos = 0;
		}
		
		if(xvgNeg == 0 && xV > 0)
		{
			xvgPos = 1;	
		}
		if(xvgPos == 0 && xV < 0)
		{
			xvgNeg = 1;	
		}
		if(xvgPos == 1 && xV < 0)
		{
			xvPos = 1;
			xV = 0;
		}
		if(xvgNeg == 1 && xV > 0)
		{
			xvNeg = 1;
			xV = 0; 
		}
		
		yAccDec = yAccRaw * 100;
		yAccDec = round(yAccDec);
		yAccRaw = yAccDec/100;

		if(yvPos == 0 && yvNeg == 0 && (yAccRaw > 0.01 || yAccRaw < -0.01) ) //Nog finetunnen
		{
			yPosNew = yPosOld + yV * t + 0.5 * (yAccRaw * 9.81) * t * t;
			yV = yV + yAccRaw * t;
			yPosOld = yPosNew;
		}
		if(yAccRaw <= 0.01 && yAccRaw >= -0.01) //Nog finetunnen
		{
			yDrift = yDrift + 1;
		}
		
		if(yDrift == 8) //Nog finetunen
		{
			yV = 0;
			yDrift = 0;
			yvgPos = 0;
			yvgNeg = 0;
			yvNeg = 0;
			yvPos = 0;
		}
		
		if(yvgNeg == 0 && yV > 0)
		{
			yvgPos = 1;
		}
		if(yvgPos == 0 && yV < 0)
		{
			yvgNeg = 1;
		}
		if(yvgPos == 1 && yV < 0)
		{
			yvPos = 1;
			yV = 0;
		}
		if(yvgNeg == 1 && yV > 0)
		{
			yvNeg = 1;
			yV = 0;
		}
		
    }
}

int round(float number)
{
	int roundNumber = number;
	number = number - roundNumber;
	if(number >= 0.5){
		number = number + 0.5;
	}
	roundNumber = roundNumber + number;
	return roundNumber;
}