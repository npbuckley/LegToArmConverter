#----------------------------------------------------
#
# LEG to ARM Converter
# by Nicholas Buckley
# v1.0 (Sep 2023)
#
#----------------------------------------------------
import re
import sys

# Construct instruction from array of elements
def construct_line(array):
    finished = array[0] + " "

    for t in array[1:-1]:
        finished += t + ", "

    finished += array[-1]
    return finished

# Check that the last argument IS an immediate
def yes_i_check(s):
    if s[-1][0].upper() == "X":
        raise Exception("Line \"" + construct_line(s) + "\" is not valid LEG. The last argument must be an immediate.")
    
# Check that the last argument is NOT an immediate
def no_i_check(s):
    if s[-1][0].upper() != "X":
        raise Exception("Line \"" + construct_line(s) + "\" is not valid LEG. The last argument must be a register.")

# Check that the second argument IS a float register
def yes_f_check(s):
    if s[1][0].upper() != "D":
        raise Exception("Line \"" + construct_line(s) + "\" is not valid LEG. The load/store register must be a double register.")
    
# Check that the second argument IS a float register
def no_f_check(s):
    if s[1][0].upper() == "D":
        raise Exception("Line \"" + construct_line(s) + "\" is not valid LEG. The load/store register must not be a double register.")
    

def convert_line(original_line):
    label = ""
    comment = ""
    line = original_line

    # Remove comment from end of line
    if line.find("//") > 0:
        start = line.index("//")
        comment = line[start:]
        line = line[:start]

    # Remove label from beginning of line
    if line.find(":") > 0:
        colon = line.index(":")
        label = line[:colon+1]
        line = line[colon+1:]

    # split the rest of the string along spaces and ',' and remove empty strings
    tokens = [s for s in re.split(',| ', line.strip()) if s]

    # Skip instructionless lines
    if tokens == []:
        return original_line
    
    # Change instruction to all uppercase
    tokens[0] = tokens[0].upper()
    

    # Remove 'I' from the end of immediate instructions
    if tokens[0] == "ADDI" or tokens[0] == "ANDI" \
    or tokens[0] == "EORI" or tokens[0] == "ORRI" \
    or tokens[0] == "SUBI" or tokens[0] == "CMPI":
        yes_i_check(tokens)

        # Check that the stack pointer is being moved in blocks of 16
        if tokens[1].upper() == "SP" and (tokens[0] == "ADDI" or tokens[0] == "SUBI"):
            if int(tokens[-1].replace("#", "")) % 16 != 0:
                raise Exception("Line \"" + construct_line(tokens) + "\" is not valid. Stack pointer must be moved by a factor of 16.")
            
        tokens[0] = tokens[0][:-1]

    # Remove 'IS' from the end of immeidate flag instructions
    elif tokens[0] == "ADDIS" or tokens[0] == "ANDIS" \
      or tokens[0] == "SUBIS":
        yes_i_check(tokens)
        tokens[0] = tokens[0][:-2] + tokens[0][-1]

    # Check that last argument is a register not an immediate
    elif tokens[0] == "ADD" or tokens[0] == "AND" \
      or tokens[0] == "EOR" or tokens[0] == "ORR" \
      or tokens[0] == "SUB" or tokens[0] == "CMP" \
      or tokens[0] == "ADDS" or tokens[0] == "ANDS" \
      or tokens[0] == "SUBS":
        no_i_check(tokens)


    # Remove 'S' and 'D' from float load instruction
    elif tokens[0] == "LDURS" or tokens[0] == "LDURD":
        yes_f_check(tokens)
        tokens[0] = "LDUR"

    # Remove 'S' and 'D' from float store instruction
    elif tokens[0] == "STURS" or tokens[0] == "STURD":
        yes_f_check(tokens)
        tokens[0] = "STUR"

    # Check that first argument is not floating point
    elif tokens[0] == "STUR" or tokens[0] == "LDUR":
        no_f_check(tokens)

    # Remove 'W' from single-word store instruction
    elif tokens[0] == "STURW":
        tokens[0] = "STUR"

    # Remove 'S' and 'D' from float operation instructions
    elif tokens[0] == "FADDS" or tokens[0] == "FADDD" \
      or tokens[0] == "FCMPS" or tokens[0] == "FCMPD" \
      or tokens[0] == "FDIVS" or tokens[0] == "FDIVD" \
      or tokens[0] == "FMULS" or tokens[0] == "FMULD" \
      or tokens[0] == "FSUBS" or tokens[0] == "FSUBD":
        tokens[0] = tokens[0][:-1]


    # Convert LDA to ADR
    elif tokens[0] == "LDA":
        tokens[0] = "ADR"

    #If not recognized, return original line
    else:
        return original_line

    return label + construct_line(tokens) + comment

def main():
    in_file = open(sys.argv[1], "r")
    out_file = open(sys.argv[2], "w")
    lines = in_file.readlines()

    for l in lines:
        newline = convert_line(l)
        if(newline[-1] != '\n'):
            out_file.write(convert_line(l) + '\n')
        else:
            out_file.write(convert_line(l))

    print("Conversion Successful :)")

if __name__ == "__main__":
    main()