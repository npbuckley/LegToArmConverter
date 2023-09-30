  .text
  .global _start
_start:
  .global add2_func
add2_func:
  LDA X8, in1
  LDUR X0, [X8, #0]
  LDA X8, in2
  LDUR X1, [X8, #0]
  ADD X2, X1, X0
add2_end:
  MOV X0, #0
  MOV W8, #93
  SVC #0

  .data
in1: 
  .dword 10
in2:
  .dword 15

.end