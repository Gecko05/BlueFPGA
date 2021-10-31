#ifndef BLUE_INSTRUCTIONS_H
#define BLUE_INSTRUCTIONS_H

#include <stdint.h>

typedef const enum {
	HLT,
	ADD,
	XOR,
	AND,
	IOR,
	NOT,
	LDA,
	STA,
	SRJ,
	JMA,
	JMP,
	INP,
	OUT,
	RAL,
	CSA,
	NOP,
	INSTRUCTIONS,
} Instruction;

#endif // BLUE_INSTRUCTIONS_H