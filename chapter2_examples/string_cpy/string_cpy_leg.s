  .text
  .global _start
  .extern printf

_start:
  .global strcpy

  LDA X0, copy
  LDA X1, original

  BL strcpy

  LDA X1, original
  LDA X2, copy
  LDA X0, output
  BL printf

  MOV X0, #0
  MOV w8, #93
  svc #0


strcpy:	
    SUBI SP, SP, #16
    STUR X19,[SP, #0]
    ADD X19, XZR, XZR
L1: ADD X10, X19, X1
    LDURB W11,[X10,#0]
    ADD X12, X19, X0
    STURB W11,[X12,#0]
    CBZ W11, L2
    ADDI X19, X19, #1
    B L1
L2: LDUR X19,[SP, #0]
    ADDI SP, SP, #16
    BR LR


.data
    original: .string "a b c d e"
    output: .string "original:%s\ncopy:%s\n"

.bss
    copy: .space 10

.end