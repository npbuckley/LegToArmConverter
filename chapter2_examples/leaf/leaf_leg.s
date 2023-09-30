  .text
  .global _start
  .extern printf

_start:
  .global leaf

  MOV X0, #10
  MOV X1, #5
  MOV X2, #6
  MOV X3, #1

  BL leaf

  MOV X1, X0
  LDA X0, output
  BL printf

  MOV X0, #0
  MOV w8, #93
  svc #0


leaf:
  SUBI SP,SP,#32
  STUR X10,[SP,#16]
  STUR X9,[SP,#8]
  STUR X19,[SP,#0]
  ADD X9,X0,X1
  ADD X10,X2,X3
  SUB X19,X9,X10
  ADD X0,X19,XZR
  LDUR X10,[SP,#16]
  LDUR X9,[SP,#8]
  LDUR X19,[SP,#0]
  ADDI SP,SP,#32
  BR LR

.data
    output: .string "%d\n"
  
.end