from sys import *


def make_opcode(one, second, lastb, last):
    if one=="0":
        ans = "0000"
    elif one=="1":
        ans = "0001"
    elif one=="2":
        ans = "0010"
    elif one=="3":
        ans = "0011"
    elif one=="4":
        ans = "0100"
    elif one=="5":
        ans = "0101"
    elif one=="6":
        ans = "0110"
    elif one=="7":
        ans = "0111"
    elif one=="8":
        ans = "1000"
    elif one=="9":
        ans = "1001"
    elif one=="a":
        ans = "1010"
    elif one=="b":
        ans = "1011"
    elif one=="c":
        ans = "1100"
    elif one=="d":
        ans = "1101"
    elif one=="e":
        ans = "1110"
    elif one=="f":
        ans = "1111"

    if second=="0" or second=="1" or second=="2" or second=="3":
        ans += "00"
    elif second=="4" or second=="5" or second=="6" or second=="7":
        ans += "01"
    elif second=="8" or second=="9" or second=="a" or second=="b":
        ans += "10"
    elif second=="c" or second=="d" or second=="e" or second=="f":
        ans += "11"

    if lastb=="0" or lastb=="4" or lastb=="8" or lastb=="c":
        ans2 = "00"
    elif lastb=="1" or lastb=="5" or lastb=="9" or lastb=="d":
        ans2 = "01"
    elif lastb=="2" or lastb=="6" or lastb=="a" or lastb=="e":
        ans2 = "10"
    elif lastb=="3" or lastb=="7" or lastb=="b" or lastb=="f":
        ans2 = "11"

    if last=="0":
        ans2 += "0000"
    elif last=="1":
        ans2 += "0001"
    elif last=="2":
        ans2 += "0010"
    elif last=="3":
        ans2 += "0011"
    elif last=="4":
        ans2 += "0100"
    elif last=="5":
        ans2 += "0101"
    elif last=="6":
        ans2 += "0110"
    elif last=="7":
        ans2 += "0111"
    elif last=="8":
        ans2 += "1000"
    elif last=="9":
        ans2 += "1001"
    elif last=="a":
        ans2 += "1010"
    elif last=="b":
        ans2 += "1011"
    elif last=="c":
        ans2 += "1100"
    elif last=="d":
        ans2 += "1101"
    elif last=="e":
        ans2 += "1110"
    elif last=="f":
        ans2 += "1111"

    if ans=="111100":
        return "OUT"
    elif ans=="111011":
        return "IN"
    elif ans=="111001":
        return "SWC1"
    elif ans=="110001":
        return "LWC1"
    elif ans=="101011":
        return "SW"
    elif ans=="100011":
        return "LW"
    elif ans=="010001":
        if ans2=="000000":
            return "ADD.S"
        elif ans2=="000001":
            return "SUB.S"
        elif ans2=="000010":
            return "MUL.S"
        elif ans2=="000011":
            return "DIV.S"
        elif ans2=="111100":
            return "C.eq.S"
        elif ans2=="111101":
            return "C.le.S"
        elif ans2=="111110":
            return "C.lt.S"
    elif ans=="001101":
        return "ORI"
    elif ans=="001100":
        return "ANDI"
    elif ans=="001000":
        return "ADDI"
    elif ans=="000101":
        return "BNE"
    elif ans=="000100":
        return "BEQ"
    elif ans=="000011":
        return "JAL"
    elif ans=="000010":
        return "J"
    elif ans=="000000":
        if ans2=="001000":
            return "JR"
        elif ans2=="000000":
            return "SLL"
        elif ans2=="000010":
            return "SRL"
        elif ans2=="000011":
            return "SRA"
        elif ans2=="100000":
            return "ADD"
        elif ans2=="100010":
            return "SUB"
        elif ans2=="100100":
            return "AND"
        elif ans2=="100101":
            return "OR"
        elif ans2=="100110":
            return "XOR"
        elif ans2=="101010":
            return "SLT"
        else:
            return ans2
    else:
        return "nazodayo"


path = str(argv[1])
path2 = str(argv[2])
instructions = []
with open(path, 'r') as f:
    for index, line in enumerate(f):
        if index >= 2:
            one = line[0]
            second = line[1]
            lastb = line[6]
            last = line[7]
            data = make_opcode(one, second, lastb, last)
            if data is not None:
                instructions.append(data)
instructions2 = list(instructions)
#instructions2.sort()
with open(path2, 'w') as g:
    for data in instructions2:
        g.write(data + "\n")
