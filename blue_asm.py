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

codeDict = {"HALT" : 0,
            "ADD" : 1,
            "XOR" : 2,
            "AND" : 3,
            "IOR" : 4,
            "NOT" : 5,
            "LDA" : 6,
            "STA" : 7,
            "SRJ" : 8,
            "JMA" : 9,
            "JMP" : 10,
            "INP" : 11,
            "OUT" : 12,
            "RAL" : 13,
            "CSA" : 14,
            "NOP" : 15,
            }

noArgs = [0, 15, 5]


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
            outputfile = 'ram.coe'
    if inputfile == '' or outputfile == '':
        print("Missing i/o filenames")
        sys.exit()
    inFile = open(inputfile, 'r')
    outFile = open(outputfile, 'w+')
    readData = inFile.read().split('\n')
    print(readData)
    outFile.write("memory_initialization_radix=16;\
                  \nmemory_initialization_vector=\n")
    for line in readData:
        if line[0:2] == '//':
            pass
        else:
            try:
                stmnt = line.split(" ")
            except:
                print("Invalid syntax")
                break
            if not(stmnt[0] in codeDict):
                hexCode = stmnt[0]
            else:
                machCode = codeDict[stmnt[0]] * (16**3)
                if machCode in noArgs:
                    pass
                else:
                    try:
                        machCode += int(stmnt[1])
                    except:
                        print("Missing argument")
                print(machCode)
                hexCode = ("{0:#0{1}x}".format(machCode, 6)[2:]).upper()
            print(hexCode)
            outFile.write(hexCode + ",\n")
    inFile.close()
    outFile.close()


if __name__ == "__main__":
    main(sys.argv[1:])