  .text
  .equ ELEM, 4
  .global _start

_start:
  .global sum1_func
sum1_func:
  MOV X0, #0
  LDA X8, vec
  MOV X7, #ELEM
  SUBI X7, X7, #1
  LSL X7, X7, #3
  ADD X7, X8, X7
loop:
  LDUR X1, [X8, #0]
  ADDI X8, X8, #8
  ADD X0, X0, X1
  CMP X7, X8
  B.GE loop
  ADR X8, out
  STUR X0, [X8, #0]
sum1_end:
  MOV X0, #0
  MOV W8, #93
  SVC #0

  .data
vec:
  .quad 1,2,3,4

  .bss
  .align 8
out:
  .space 8

  .end

