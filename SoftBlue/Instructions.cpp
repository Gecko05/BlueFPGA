#include <iostream>
#include <vector>

#include "Instructions.h"

void do_HLT(uint8_t tick)
{
	std::cout << "Hello" << std::endl;
}
void do_ADD(uint8_t tick)
{
	std::cout << "Hello" << std::endl;
}
void do_XOR(uint8_t tick)
{
	std::cout << "Hello" << std::endl;
}
void do_IOR(uint8_t tick)
{
	std::cout << "Hello" << std::endl;
}
void do_NOT(uint8_t tick)
{
	std::cout << "Hello" << std::endl;
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
	std::cout << "Hello" << std::endl;
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
	std::cout << "Hello" << std::endl;
}

std::vector<void (*)(uint8_t tick)> instruction_callback{
		do_HLT,
		do_ADD,
		do_XOR,
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

void process_tick(Instruction instruction, uint8_t tick)
{
	(*instruction_callback[instruction])(tick);
}