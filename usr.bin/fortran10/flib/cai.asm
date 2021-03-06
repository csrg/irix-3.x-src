        IDENT   CMPLX_IFACE

; INTERFACE ROUTINE FOR COMPLEX ARITHMETIC.

; COPYRIGHT 1981, RICHARD E. JAMES III.

; THE COMPILER PUSHES THE OPERAND VALUES ONTO THE STACK
;   AND ASSUMES NO REGISTERS DESTROYED.

        GLOBAL  %C_ADD,%C_SUB,%C_MUL,%C_DIV
        EXTERN  %C_ARI
NSAVED  EQU     12*4

%C_ADD
;------
        MOVE.L  #1,-(SP)       ;CODE FOR ADD
        BRA.S   WORK
%C_SUB
;------
        MOVE.L  #2,-(SP)       ;CODE FOR SUB
        BRA.S   WORK
%C_MUL
;------
        MOVE.L  #3,-(SP)       ;CODE FOR MUL
        BRA.S   WORK
%C_DIV
;------
        MOVE.L  #4,-(SP)       ;CODE FOR DIV
;       BRA.S   WORK

WORK
        MOVEM.L D0-D7/A0-A3,-(SP)      ;SAVE REGISTERS
        PEA     NSAVED(SP)             ;->N
        PEA     NSAVED+5*4(SP)         ;REAL
        PEA     NSAVED+7*4(SP)         ;IMAG OF FIRST
        PEA     NSAVED+5*4(SP)         ;REAL
        PEA     NSAVED+7*4(SP)         ;IMAG OF SECOND
; STACK NOW HAS
;   AI,AR,BI,BR,RTS,N,REGS...,->N,->AR,->AI,->BR,->BI
;
        JSR     %C_ARI
; THE ANSWER WAS PUT INTO AR,AI
        MOVEM.L (SP)+,D0-D7/A0-A3      ;RESTORE REGISTERS
        ADDQ.L  #4,SP          ;POP N
        MOVE.L  (SP)+,(SP)
        MOVE.L  (SP)+,(SP)     ;MOVE RETURN ADDR
        RTS                    ;LEAVE WITH RESULT ON TOP OF STACK

        END

                                                                                                                                                                                                                                    