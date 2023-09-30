  .text
  .equ ELEM, 10
  .global _start

_start:
  .global _start
sum3_func:
ADR X0, stack
  MOV SP, X0
SUB SP, SP, #16
STUR X30, [SP, #0]
  MOV X2, #ELEM
ADR X1, vec
  BL fsum
ADR X8, out
STUR X0, [X8, #0]
sum3_end:
LDUR X30, [SP, #0]
ADD SP, SP, #16
  MOV X0, #0
  MOV W8, #93
  SVC #0

  .func fsum
fsum:
SUB SP, SP, #32
STUR X1, [SP, #0]
STUR X2, [SP, #8]
STUR X3, [SP, #16]
STUR X30, [SP, #24]
CMP X2, #1
  B.HI fsum_split
LDUR X0, [X1, #0]
  B fsum_end
fsum_split:
  LSR X9, X2, #1
  MOV X3, X9
SUB X2, X2, X3
  BL fsum
  LSL X9, X2, #3
ADD X1, X1, X9
  MOV X2, X3
  MOV X3, X0
  BL fsum
ADD X0, X0, X3
fsum_end:
LDUR X1, [SP, #0]
LDUR X2, [SP, #8]
LDUR X3, [SP, #16]
LDUR X30, [SP, #24]
ADD SP, SP, #32
  BR X30
  .endfunc

  .data
vec:
  .quad 1,2,3,4,5,6,7,8,9,10 // element
  .bss
  .align 8
out:
  .space 8// space for the result
  .align 16
  .space 4096 // space for the stack
stack:
  .space 16 // stack base address
  .end
