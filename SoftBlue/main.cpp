#include <iostream>
#include <vector>

#include "Instructions.h"

// Sample program
uint16_t program[2] = {
	0xF000,
};

#define RAM_LENGTH 4096

uint16_t RAM[RAM_LENGTH];

uint8_t clock_pulse = 0; // Each pulse, this will increment
typedef uint16_t register_t;

register_t PC, ACC, Z, MAR, MBR, INS;

void tick_clock()
{
	clock_pulse++;
	clock_pulse %= 8;
}

void emulateCycle()
{
	while (clock_pulse < 7)
	{
		tick_clock();
		process_tick(HLT, clock_pulse);
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