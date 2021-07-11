# Assembler for BLU
import sys
from enum import Enum
import getopt

class Inst(Enum):
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

codeDict = {"HALT" : Inst.HALT,
            "ADD" : Inst.ADD,
            "XOR" : Inst.XOR,
            "AND" : Inst.AND,
            "IOR" : Inst.IOR,
            "NOT" : Inst.NOT,
            "LDA" : Inst.LDA,
            "STA" : Inst.STA,
            "SRJ" : Inst.SRJ,
            "JMA" : Inst.JMA,
            "JMP" : Inst.JMP,
            "INP" : Inst.INP,
            "OUT" : Inst.OUT,
            "RAL" : Inst.RAL,
            "CSA" : Inst.CSA,
            "NOP" : Inst.NOP,
            }

def main(argv):
    inputfile = ''
    outputfile = ''
    try:
        opts, args = getopt.getopt(argv, "hbi:o:",["ifile=","ofile="])
    except getopt.GetoptError:
        print('blu.py -i <inputfile> -o <outputfile>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('Usage: blu.py [options] file\
               \nOptions:\
               \n -h: help\
               \n -b: Generate ram.coe file')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            if outputfile == '':
                outputfile = arg
        elif opt == '-b':
            print('Generating ram.coe')
            outputfile = 'ram_test.coe'
    if inputfile == '' or outputfile == '':
        sys.exit()
    inFile = open(inputfile, 'r')
    outFile = open(outputfile, 'w+')
    readData = inFile.read().split('\n')
    print(readData)
    for line in readData:
        if line[0:2] == '//':
            pass
        try:
            stmnt = line.split(" ")
        except:
            print("Invalid syntax")
            break
        if not(stmnt[0] in codeDict):
            print("Invalid syntax")
            break
        machCode = codeDict[stmnt]
        hexCode = str(hex(machCode))[2:]
        outFile.write(hexCode + ",\n")
    inFile.close()
    outFile.close()


if __name__ == "__main__":
    main(sys.argv[1:])