  .text
  .global _start
_start:
  .global add2_func
add3_func:
  LDA X8, in1
  LDUR X0, [X8, #0]
  LDA X8, in2
  LDUR X1, [X8, #0]
  ADD X0, X0, X1
  LDA X8, out
  STUR X0, [X8, #0]
add3_end:
  MOV X0, #0
  MOV W8, #93
  SVC #0

  .data
in1: 
  .quad 10
in2:
  .quad 15

  .bss
  .align 8
out:
  .space 8

.end