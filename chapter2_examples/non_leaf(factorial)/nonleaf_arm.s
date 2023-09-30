    .text
    .global _start
    .extern printf

_start:
    .global fact

    MOV X0, #10

    BL fact

ADR X0, output
    BL printf

    MOV X0, #0
    MOV w8, #93
    svc #0


fact:
SUB SP, SP, #16
    STUR LR,[SP,#8]
    STUR X0,[SP,#0]
SUBS XZR, X0, #1
    B.GE L1
    MOV X1, #1
ADD SP, SP, #16
    BR LR
L1:SUB X0, X0, #1
    BL fact
    LDUR X0,[SP,#0]
    LDUR LR,[SP,#8]
ADD SP, SP, #16
    MUL X1,X0,X1
    BR LR

.data
    output: .string "%d\n"

.end
