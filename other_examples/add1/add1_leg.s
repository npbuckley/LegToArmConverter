  .text
  .global _start
_start:
  .global add1_func
add1_func:
  MOV X0, #10
  MOV X1, #15
  ADD X2, X1, X0
add1_end:
  MOV X0, #0
  MOV W8, #93
  SVC #0
.end