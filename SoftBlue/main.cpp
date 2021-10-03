#include <iostream>
#include <vector>

#include "Instructions.h"

#define RAM_LENGTH 4096
typedef uint16_t register_t;

bool fetch = true;
bool power = false;
bool transfer = false;

register_t PC = 0x00;
register_t A;
register_t Z;
register_t MAR;
register_t MBR;
register_t IR;
uint16_t RAM[RAM_LENGTH];
uint8_t clock_pulse = 0; // Each pulse, this will increment

void press_ON()
{
	std::cout << "Pressed ON" << std::endl;
	power = true;
}

void press_OFF()
{
	std::cout << "Pressed OFF" << std::endl;
	power = false;
}

// Sample program
uint16_t program[2] = {
	0xF000,
	0x0000,
};


void do_HLT(uint8_t tick)
{
	std::cout << "HLT" << std::endl;
	if (tick == 6)
		power = false;
	else if (tick == 7)
		MAR = PC;
}
void do_ADD(uint8_t tick)
{
	std::cout << "ADD" << std::endl;
	if (fetch == true) {
		if (tick == 5)
			Z = 0;
		else if (tick == 6)
			Z = A;
		else if (tick == 7)
			MAR = (IR & 0x0FFF);
			fetch = false;
	}
	else {
		if (tick == 2)
			A = MBR = 0;
		if (tick == 3)
			MBR = RAM[MAR];
		else if (tick == 6)
			A = Z + MBR;
		else if (tick == 7)
			MAR = PC;
			fetch = true;
	}
}
void do_XOR(uint8_t tick)
{
	std::cout << "XOR" << std::endl;
	if (fetch == true) {
		if (tick == 5)
			Z = 0;
		else if (tick == 6)
			Z = A;
		else if (tick == 7)
			MAR = (IR & 0x0FFF);
		fetch = false;
	}
	else {
		if (tick == 2)
			A = MBR = 0;
		if (tick == 3)
			MBR = RAM[MAR];
		else if (tick == 6)
			A = Z ^ MBR;
		else if (tick == 7)
			MAR = PC;
		fetch = true;
	}
}
void do_AND(uint8_t tick)
{
	std::cout << "AND" << std::endl;
	if (fetch == true) {
		if (tick == 5)
			Z = 0;
		else if (tick == 6)
			Z = A;
		else if (tick == 7)
			MAR = (IR & 0x0FFF);
		fetch = false;
	}
	else {
		if (tick == 2)
			A = MBR = 0;
		if (tick == 3)
			MBR = RAM[MAR];
		else if (tick == 6)
			A = Z & MBR;
		else if (tick == 7)
			MAR = PC;
		fetch = true;
	}
}
void do_IOR(uint8_t tick)
{
	std::cout << "IOR" << std::endl;
	if (fetch == true) {
		if (tick == 5)
			Z = 0;
		else if (tick == 6)
			Z = A;
		else if (tick == 7)
			MAR = (IR & 0x0FFF);
		fetch = false;
	}
	else {
		if (tick == 2)
			A = MBR = 0;
		if (tick == 3)
			MBR = RAM[MAR];
		else if (tick == 6)
			A = Z | MBR;
		else if (tick == 7)
			MAR = PC;
		fetch = true;
	}
}
void do_NOT(uint8_t tick)
{
	std::cout << "NOT" << std::endl;
}
void do_LDA(uint8_t tick)
{
	std::cout << "Hello" << std::endl;
}
void do_STA(uint8_t tick)
{
	std::cout << "Hello" << std::endl;
}
void do_SRJ(uint8_t tick)
{
	std::cout << "Hello" << std::endl;
}
void do_JMA(uint8_t tick)
{
	std::cout << "Hello" << std::endl;
}
void do_JMP(uint8_t tick)
{
	std::cout << "JMP" << std::endl;
	if (tick == 5)
		PC = 0;
	else if (tick == 6)
		PC = (IR & 0x0FFF);
	else if (tick == 7)
		MAR = PC;
}
void do_INP(uint8_t tick)
{
	std::cout << "Hello" << std::endl;
}
void do_OUT(uint8_t tick)
{
	std::cout << "Hello" << std::endl;
}
void do_RAL(uint8_t tick)
{
	std::cout << "Hello" << std::endl;
}
void do_CSA(uint8_t tick)
{
	std::cout << "Hello" << std::endl;
}
void do_NOP(uint8_t tick)
{
	std::cout << "NOP" << std::endl;
	if (tick == 7)
		MAR = PC;
}

std::vector<void (*)(uint8_t tick)> instruction_callback{
		do_HLT,
		do_ADD,
		do_XOR,
		do_AND,
		do_IOR,
		do_NOT,
		do_LDA,
		do_STA,
		do_SRJ,
		do_JMA,
		do_JMP,
		do_INP,
		do_OUT,
		do_RAL,
		do_CSA,
		do_NOP,
};

void process_tick(uint8_t tick)
{
	
	switch (tick) {
	case 0x00:
		break;
	case 0x01:
		break;
	case 2:
		if (fetch == true)
			PC += 1;
		break;
	case 3:
		if (fetch == true)
			MBR = 0x00;
		break;
	case 4:
		if (fetch == true)
			IR = 0x00;
			MBR = RAM[MAR];
		break;
	case 5:
		if (fetch == true)
			IR = MBR;
		break;
	case 6:
		break;
	case 7:
		break;
	default:
		break;
	}
	uint8_t INS = ((IR & 0xF000) >> 12);
	(*instruction_callback[INS])(tick);
}

void tick_clock()
{
	clock_pulse++;
	clock_pulse %= 8;
}

void emulateCycle()
{
	while (clock_pulse < 7)
	{
		process_tick(clock_pulse);
		tick_clock();
	}
	clock_pulse = 0;
}

int main(int argc, char* argv[])
{
	std::cout << "Running soft blue" << std::endl;
	std::cout << "Copying program to the RAM" << std::endl;
	memset(RAM, 0x00, RAM_LENGTH);
	for (int i = 0; i < 2; i++)
	{
		RAM[i] = program[i];
	}
	press_ON();
	for (;;)
	{
		emulateCycle();
		while (power == false) {
			std::cout << "Stopped" << std::endl;
			if (getchar())
				power = true;
				std::cout << "Resuming..." << std::endl;
		}
	}
	return 0;
}