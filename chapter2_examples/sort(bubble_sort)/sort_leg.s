  .text
  .global _start
  .extern printf

_start:
  .global sort

  // MOV Arguments Here
  LDA X0, array
  LDA X1, size
  LDUR X1, [X1, #0]

  // Call Function Here
  BL sort

  // Print Array
  LDA X0, array
  LDA X1, size
  LDUR X1, [X1, #0]
  BL print_array

  MOV X0, #0
  MOV w8, #93
  svc #0

sort: 
    SUBI SP,SP,#48 	// make room on stack for 5 regs
	STUR LR,[SP,#32]	// save LR on stack
	STUR X22,[SP,#24]	// save X22 on stack
	STUR X21,[SP,#16]	// save X21 on stack
	STUR X20,[SP,#8]	// save X20 on stack
	STUR X19,[SP,#0]	// save X19 on stack
	MOV X21, X0		// copy parameter X0 into X21
	MOV X22, X1		// copy parameter X1 into X22

    MOV X19,XZR		// i = 0
for1tst:
	CMP X19, X22		// compare X19 to X1 (i to n)
	B.GE exit1		// go to exit1 if X19 ≥ X1 (i≥n)

	SUBI X20, X19, #1	// j = i - 1
for2tst: CMP X20,XZR		// compare X20 to 0 (j to 0)
    B.LT exit2		// go to exit2 if X20 < 0 (j < 0)
    LSL X10, X20, #3	// reg X10 = j * 8
    ADD X11, X0, X10	// reg X11 = v + (j * 8)
    LDUR X12, [X11,#0]	// reg X12 = v[j]
    LDUR X13, [X11,#8]	// reg X13 = v[j + 1]
    CMP X12, X13		// compare X12 to X13
    B.LE exit2		// go to exit2 if X12 ≤ X13
    MOV X0, X21		// first swap parameter is v
    MOV X1, X20		// second swap parameter is j
    BL swap			// call swap
    SUBI X20, X20, #1	// j –= 1
    B for2tst		// branch to test of inner loop
exit2:
	ADDI X19,X19,#1		// i += 1
	B for1tst			// branch to test of outer loop
exit1:
    LDUR X19, [SP,#0]	// restore X19 from stack
	LDUR X20, [SP,#8]	// restore X20 from stack
	LDUR X21,[SP,#16]	// restore X21 from stack
	LDUR X22,[SP,#24]	// restore X22 from stack
	LDUR LR,[SP,#32]	// restore LR from stack
	ADDI SP,SP,#48		// restore stack pointer
    BR LR

swap: LSL X10, X1, #3
    ADD X10, X0, X10
    LDUR X9, [X10, #0]
    LDUR X11, [X10, #8]
    STUR X11, [X10, #0]
    STUR X9, [X10, #8]
    BR LR

print_array:
  SUBI SP, SP, #32
  STUR X19, [SP, #0]
  STUR X20, [SP, #8]
  STUR X21, [SP, #16]
  STUR LR, [SP, #32]
  MOV X19, #0
  MOV X20, X0
  MOV X21, X1
print_loop:
  CMP X19, X21
  B.GE print_exit
  LSL X9, X19, #3
  ADD X10, X20, X9
  LDUR X1, [X10, #0]
  LDA X0, print_string
  BL printf
  ADDI X19, X19, #1
  B print_loop
print_exit:
  ADR X0, print_string_end
  BL printf
  LDUR X19, [SP, #0]
  LDUR X20, [SP, #8]
  LDUR X21, [SP, #16]
  LDUR LR, [SP, #32]
  ADDI SP, SP, #32
  BR LR

  .data
array: .dword 9,8,7,6,5,4,3,2,1
size: .dword 9

print_string: .string "%d "
print_string_end: .string "\n"   

  .end