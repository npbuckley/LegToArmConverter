  .text
  .equ ELEM, 10
  .global _start

_start:
  .global sum2_func
sum2_func:
  LDA X0, stack
  MOV SP, X0
  SUBI SP, SP, #16
  STUR X30, [SP, #0]
  MOV X2, #ELEM
  LDA X1, vec
  BL fsum
  STUR X0, [X8, #0]
sum2_end:
  LDUR X30, [SP #0]
  ADDI SP, SP, #16
  MOV X0, #0
  MOV W8, #93
  SVC #0

  .func fsum
fsum:
  SUBI SP, SP, #16
  STUR X2, [SP, #0]
  STUR X3, [SP, #8]
  MOV X0, #0
  SUBI X2, X2, #1
fsum_l:
  LSL X9, X2, #3
  ADD X9, X1, X9
  LDUR X3, [X9, #0]
  ADD X0, X0, X3
  SUBIS X2, X2, #1
  B.GE fsum_l
  LDUR X2, [SP, #0]
  LDUR X3, [SP, #8]
  ADDI SP, SP, #16
  BR LR
  .endfunc

  .data
vec:
  .quad 1,2,3,4,5,6,7,8,9,10 // element
 .bss
  .align 8
out:
  .space 8	// space for the result
  .align 16
  .space 4096 // space for the stack
stack:
  .space 16 	// stack base address (16 bytes)
  .end
