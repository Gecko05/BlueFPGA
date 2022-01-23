#include <fstream>
#include <iostream>
#include <string.h>
#include <string>
#include <vector>
#include <unordered_map>
#include <algorithm>

#include "Instructions.h"

#define RAM_LENGTH 4096
const int DUMP_COLS = 16;
typedef uint16_t blue_register;

typedef enum {
	EXECUTE,
	FETCH,
} State;


bool printRegistersEveryCycle = true;

State STATE = FETCH;
bool power = false;
bool TRA = false;

blue_register PC = 0x00;
blue_register A;
blue_register Z;
blue_register SR;
// There're multiple ways to handle MAR/MBR. Using either pointers, references
// or operator overloading.
blue_register MAR;
blue_register MBR;
blue_register IR;

uint16_t RAM[RAM_LENGTH];
blue_register DSL;
blue_register DIL;
uint8_t R;
uint8_t clock_pulse = 0; // Each pulse, this will increment

// Sample program
uint16_t program0[8] = {
	0xF000,
	0xA003,
	0x0000,
	0x1005,
	0x1006,
	0x0005,
	0x0008,
	0x0000
};

std::unordered_map<std::string, blue_register*> BLUE_registers = {
	{"PC", &PC},
	{"A", &A},
	{"Z", &Z},
	{"SR", &SR},
	{"MAR", &MAR},
	{"MBR", &MBR},
	{"IR", &IR},
	{"DSL", &DSL},
	{"DIL", &DIL}
};
std::vector<blue_register> breakpoints{};

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

void do_HLT(uint8_t tick)
{
	if (tick == 6)
		power = false;
	else if (tick == 7)
		MAR = PC;
}

void do_ADD(uint8_t tick)
{
	if (STATE == FETCH) {
		if (tick == 5)
			Z = 0;
		else if (tick == 6)
			Z = A;
		else if (tick == 7){
			MAR = (IR & 0x0FFF);
			STATE = EXECUTE;
		}
	}
	else {
		if (tick == 2)
			A = MBR = 0;
		else if (tick == 3)
			MBR = RAM[MAR];
		else if (tick == 6) {
			uint32_t result = Z + MBR;
			if ((Z & 0x8000) && (MBR & 0x8000) && !(result & 0x8000))
				power = false; // Negative overflow
			else if (!(Z & 0x8000) && !(MBR & 0x8000) && (result & 0x8000))
				power = false; // Positive overflow
			A = static_cast<uint16_t>(result);
		}
		else if (tick == 7) {
			MAR = PC;
			STATE = FETCH;
		}
	}
}

void do_XOR(uint8_t tick)
{
	if (STATE == FETCH) {
		if (tick == 5)
			Z = 0;
		else if (tick == 6)
			Z = A;
		else if (tick == 7) {
			MAR = (IR & 0x0FFF);
			STATE = EXECUTE;
		}
	}
	else {
		if (tick == 2)
			A = MBR = 0;
		else if (tick == 3)
			MBR = RAM[MAR];
		else if (tick == 6)
			A = Z ^ MBR;
		else if (tick == 7) {
			MAR = PC;
			STATE = FETCH;
		}
	}
}

void do_AND(uint8_t tick)
{
	if (STATE == FETCH) {
		if (tick == 5)
			Z = 0;
		else if (tick == 6)
			Z = A;
		else if (tick == 7) {
			MAR = (IR & 0x0FFF);
			STATE = EXECUTE;
		}
	}
	else {
		if (tick == 2)
			A = MBR = 0;
		else if (tick == 3)
			MBR = RAM[MAR];
		else if (tick == 6)
			A = Z & MBR;
		else if (tick == 7) {
			MAR = PC;
			STATE = FETCH;
		}
	}
}

void do_IOR(uint8_t tick)
{
	if (STATE == FETCH) {
		if (tick == 5)
			Z = 0;
		else if (tick == 6)
			Z = A;
		else if (tick == 7) {
			MAR = (IR & 0x0FFF);
			STATE = EXECUTE;
		}
	}
	else {
		if (tick == 2)
			A = MBR = 0;
		else if (tick == 3)
			MBR = RAM[MAR];
		else if (tick == 6)
			A = Z | MBR;
		else if (tick == 7) {
			MAR = PC;
			STATE = FETCH;
		}
	}
}

void do_NOT(uint8_t tick)
{
	if (STATE == FETCH) {
		if (tick == 5)
			Z = 0;
		else if (tick == 6)
			Z = A;
		else if (tick == 7) {
			STATE = EXECUTE;
		}
	}
	else {
		if (tick == 0)
			A = 0;
		else if (tick == 1)
			A = ~Z;
		else if (tick == 7) {
			MAR = PC;
			STATE = FETCH;
		}
	}
}

void do_LDA(uint8_t tick)
{
	if (STATE == FETCH) {
		if (tick == 7) {
			STATE = EXECUTE;
			MAR = (IR & 0x0FFF);
		}
	} else if (STATE == EXECUTE) {
		if (tick == 1) {
			A = 0;
		} else if (tick == 2) {
			MBR = 0;
		} else if (tick == 4) {
			A = MBR = RAM[MAR];
		} else if (tick == 7) {
			MAR = PC;
			STATE = FETCH;
		}
	}
}

void do_STA(uint8_t tick)
{
	if (STATE == FETCH) {
		if (tick == 7) {
			STATE = EXECUTE;
			MAR = (IR & 0x0FFF);
		}
	} else if (STATE == EXECUTE) {
		if (tick == 3) {
			MBR = 0;
		} else if (tick == 4) {
			RAM[MAR] = MBR = A;
		} else if (tick == 7) {
			MAR = PC;
			STATE = FETCH;
		}
	}
}

void do_SRJ(uint8_t tick)
{
	if (tick == 5) {
		A = (PC & 0x0FFF);
	} else if (tick == 6) {
		PC = 0;
	} else if (tick == 7) {
		MAR = PC = (IR & 0x0FFF);
	}
}

void do_JMA(uint8_t tick)
{
	if (tick == 5) {
		if ((A & 0x8000)) {
			PC = 0;
		}
	} else if (tick == 6) {
		if ((A & 0x8000)) {
			PC = (IR & 0x0FFF);
		}
	} else if (tick == 7) {
		MAR = PC;
	}
}

void do_JMP(uint8_t tick)
{
	if (tick == 5) {
		PC = 0;
	} else if (tick == 6) {
		PC = (IR & 0x0FFF);
	} else if (tick == 7) {
		MAR = PC;
	}
}

void do_INP(uint8_t tick)
{
	if (STATE == FETCH) {
		if (tick == 5) {
			A = 0;
			DSL = (IR & 0x003F);
		} else if (tick == 6) {
			TRA = true;
		} else if (tick == 7) {
			STATE = EXECUTE;
		}
	} else if (STATE == EXECUTE) {
		if (tick == 4) {
			R = true;
			A = (DIL & 0x00FF);
		} else if (tick == 5) {
			if (R == true)
				TRA = false;
		} else if (tick == 7) {
			if (TRA == false) {
				STATE = FETCH;
				MAR = PC;
			}
		}
	}
	A = 0;
}

void do_OUT(uint8_t tick)
{
	std::cout << "Hello" << std::endl;
}

void do_RAL(uint8_t tick)
{
	if (STATE == FETCH) {
		if (tick == 5) {
			Z = 0;
		} else if (tick == 6) {
			Z = A;
		} else if (tick == 7) {
			STATE = EXECUTE;
		}
	}
	else {
		if (tick == 0) {
			A = 0;
		} else if (tick == 1) {
			A = ((Z & 0x8000) >> 15) | (Z * 2);
		} else if (tick == 7) {
			MAR = PC;
			STATE = FETCH;
		}
	}
}

void do_CSA(uint8_t tick)
{
	if (tick == 5) {
		A = 0;
	} else if (tick == 6) {
		A = SR;
	} else if (tick == 7) {
		MAR = PC;
	}
}

void do_NOP(uint8_t tick)
{
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
		if (STATE == FETCH)
			PC += 1;
		break;
	case 3:
		if (STATE == FETCH)
			MBR = 0x00;
		break;
	case 4:
		if (STATE == FETCH) {
			IR = 0x00;
			MBR = RAM[MAR];
		}
		break;
	case 5:
		if (STATE == FETCH)
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
}

void emulateCycle()
{
	while (clock_pulse < 8)
	{
		process_tick(clock_pulse);
		tick_clock();
	}
	clock_pulse = 0;
}

void dumpRegisters()
{
	printf("PC: %04x A: %04x IR: %04x Z: %04x MAR: %04x MBR: %04x DSL: %02x DIL: %02x\n", PC, A, IR, Z, MAR, MBR, (DSL & 0x00FF), (DIL & 0x00FF));
}

void dumpRAM()
{
	printf("==== RAM ====\n0000: ");
	for (int i = 1; i < RAM_LENGTH + 1; i++) {
		printf("%04x ", RAM[i-1]);
		if ((i % 8 == 0) && (i != RAM_LENGTH)) {
			printf("\n%04x: ", i - 1);
		}
	}
}

size_t getCmdOption(std::string& cmd, const std::string& option)
{
	return cmd.find(option) != std::string::npos;
}

void runProgram(const uint16_t* program)
{
	std::cout << "Copying program to the RAM\n";
	memset(RAM, 0x00, RAM_LENGTH * sizeof(uint16_t));
	memmove(RAM, program, (RAM_LENGTH * sizeof(uint16_t)));
	press_ON();
	for (;;) {
		emulateCycle();
		if (printRegistersEveryCycle) {
			dumpRegisters();
		}
		if (std::find(breakpoints.begin(), breakpoints.end(), PC) != breakpoints.end()) {
			printf("Stopped at line %i\n", PC);
			power = false;
		}
		while (power == false) {
			std::string command;
			std::getline(std::cin, command);
			if ("c" == command) {
				power = true;;
			}
			else if ("r" == command) {
				dumpRegisters();
			}
			else if ("d" == command) {
				dumpRAM();
			}
			else if ("q" == command) {
				std::cout << "Stopping...\n";
				goto quit;
			}
			else if ("s" == command) {
				// This is not ideal
				breakpoints.push_back(PC + 1);
				power = true;
			}
			else if (getCmdOption(command, "b")) {
				size_t pos = getCmdOption(command, "b");
				if (command.at(pos) != *command.end())
				{
					uint16_t line = atoi(&command.at(pos));
					std::cout << "Set breakpoint at line " << std::dec << line << "\n";
					breakpoints.push_back(line);
				}	
			}
			else if (getCmdOption(command, "x")) {
				size_t pos = getCmdOption(command, "x");
				if (command.at(pos) != *command.end())
				{
					std::string register_and_val = command.substr(pos + 1);
					blue_register val = stoi(register_and_val.substr(register_and_val.find(" ")));
					std::string register_to_mod = register_and_val.substr(0, register_and_val.find(" "));
					auto it = BLUE_registers.find(register_to_mod);
					if (it != BLUE_registers.end()) {
						blue_register* reg = it->second;
						*reg = val;
					}
					else {
						std::cout << "Invalid register name\n";
					}
				}	
			}
		}
	}
	quit: std::cout << "Finished execution" << std::endl;
}

int main(int argc, char* argv[])
{
	std::cout << "Running soft blue\n";
	uint16_t program_data[RAM_LENGTH];
	uint16_t* program = program0;

	if ((argc == 2) && (argv[1])){
		std::ifstream program_file;
		program_file.open(argv[1]);
		if (!program_file){
			std::cout << "Failed to open the program file" << std::endl;
			return 0;
		}
		memset(program_data, 0x00, RAM_LENGTH * sizeof(uint16_t));
		program_file.read((char*)program_data, RAM_LENGTH);
		program = program_data;
		program_file.close();
	}

	runProgram(program);
	return 0;
}