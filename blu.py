# Assembler for BLU
import sys
from enum import Enum
import getopt

class Instruction(Enum):
    HALT = 0
    ADD = 1
    XOR = 2
    AND = 3
    IOR = 4
    NOT = 5
    LDA = 6
    STA = 7
    SRJ = 8
    JMA = 9
    JMP = 10
    INP = 11
    OUT = 12
    RAL = 13
    CSA = 14
    NOP = 15

def main(argv):
    try:
        opts, args = getopt.getopt(argv, "hi:o:",["ifile=","ofile="])
    except getopt.GetoptError:
        print ''