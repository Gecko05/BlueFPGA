#include <iostream>
#include <vector>

#include "Instructions.h"

#define RAM_LENGTH 4096
typedef uint16_t register_t;

bool fetch = false;
bool power = false;
bool transfer = false;

register_t PC, ACC, Z, MAR, MBR, INS;
uint16_t RAM[RAM_LENGTH];
uint8_t clock_pulse = 0; // Each pulse, this will increment

void press_ON()
{
	power = true;
}

void press_OFF()
{
	power = false;
}

// Sample program
uint16_t program[2] = {
	0xF000,
};

void tick_clock()
{
	clock_pulse++;
	clock_pulse %= 8;
}

void emulateCycle()
{
	while (clock_pulse < 7)
	{
		if (power == true) {
			tick_clock();
			process_tick(HLT, clock_pulse);
		}
	}
	clock_pulse = 0;
}

int main(int argc, char* argv[])
{
	std::cout << "Running soft blue" << std::endl;
	for (;;)
	{
		emulateCycle();
	}
	return 0;
}