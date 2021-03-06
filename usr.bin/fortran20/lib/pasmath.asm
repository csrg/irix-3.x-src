; File: pasmath.text
; Date: 13-Dec-84
;

        ident   PASMATHA
        
        global  %I_MUL4,%I_DIV4,%I_MOD4
        
;
; %I_MUL4 - Multiply two 4-byte integers
;
; Parameters: ST.L - Arg 1
;             ST.L - Arg 2
;
; Returns:    ST.L - Product
;
; Scratches:  All Registers Saved
;

%I_MUL4
        move.l  d0,-(sp)        ; Save scratch registers
        move.l  d1,-(sp)
        move.w  16(sp),d0       ; A1u
        muls    14(sp),d0       ; A1u * A2l
        move.w  12(sp),d1       ; A2u
        muls    18(sp),d1       ; A2u * A1l
        add.w   d1,d0           ; A1u * A2l + A2u * A1l
        swap    d0
        clr.w   d0
        move.w  18(sp),d1       ; A1l
        mulu    14(sp),d1       ; A1l * A2l
        add.l   d1,d0           ; The Answer
        move.l  d0,16(sp)       ; Store the result
        move.l  (sp)+,d1        ; Restore scratch registers
        move.l  (sp)+,d0
        move.l  (sp)+,(sp)
        rts
        
;
; %I_MOD4 - Remainder two 4-byte integers
;
; Parameters: ST.L - Dividend
;             ST.L - Divisor
;
; Returns:    ST.L - Remainder
;
; Scratches:  All Registers Saved
;

%I_MOD4
        bsr.s   idivmod
        move.l  4(sp),8(sp)     ; Return REMAINDER
        move.l  (sp)+,(sp)
        rts
        
;
; %I_DIV4 - Divide two 4-byte integers
;
; Parameters: ST.L - Dividend
;             ST.L - Divisor
;
; Returns:    ST.L - Quotient
;
; Scratches:  All Registers Saved
;

%I_DIV4
        bsr.s   idivmod
        move.l  (sp)+,(sp)
        rts
        
;
; idivmod - Perform a 32-bit Integer Divide and Modulus
;
; Parameters:  ST.L = Dividend
;              ST.L = Divisor
;              ST.L = Extra return address
;
; Returns:     ST.L = Quotient
;              ST.L = Remainder
;              ST.L = Extra return address
;
; All registers are preserved.
;
; Does Pascal Integer Division,
;   where: sign(remaindor) = sign(divdend)
;
;  7 div  3 =  2 rem  1
; -7 div  3 = -2 rem -1
;  7 div -3 = -2 rem  1
; -7 div -3 =  2 rem -1
;

idivmod
        movem.l d0-d4,-(sp)
        moveq   #1,d4           ; D4 = Sign of quo.B and rem.W
        move.l  28(sp),d0       ; D0 = divisor
        beq.s   zerodiv         ; Jump is zero
        bge.s   dvsrpos
        neg.l   d0              ; D0 = Abs(divisor)
        neg.b   d4
dvsrpos move.l  32(sp),d1       ; D1 = dividend
        bge.s   dvndpos
        neg.l   d1              ; D1 = Abs(dividend)
        neg.b   d4
        ori.w   #$8000,d4       ; Remainder is negative
dvndpos cmpi.l  #$10000,d0      ; Is divisor small?
        bge.s   bigdvsr         ; No. Must do more work
        move.w  d1,d2           ; Yes. Do it the easy way
        clr.w   d1
        swap    d1
        divu    d0,d1           ; D1 = Int.Rem,HIQUO
        move.w  d1,d3
        move.w  d2,d1
        divu    d0,d1           ; D1 = REM,LOQUO
        swap    d1
        move.w  d1,d0           ; D0 = remainder
        move.w  d3,d1
        swap    d1              ; D1 = quotient
        bra.s   divrts
bigdvsr move.l  d0,d2           ; Save divisor
        move.l  d1,d3           ; Save dividend
scaloop lsr.l   #1,d0           ; Scale divisor
        lsr.l   #1,d1           ; Scale dividend
        cmpi.l  #$10000,d0      ; Is divisor in range?
        bge.s   scaloop         ; Not yet
        divu    d0,d1           ; Yes. Divide 'em
        andi.l  #$ffff,d1       ; Clear remainder
        move.l  d3,d0           ; D0 = dividend
        move.l  d1,-(sp)
        move.l  d2,-(sp)
        jsr     %I_MUL4         ; Multiply DVSR*QUO
        sub.l   (sp)+,d0        ; Is answer <= DVND?
        bge.s   divrts          ; Yes. REM and QUO are OK
        subq.l  #1,d1           ; No. Adjust QUO
        add.l   d2,d0           ; Adjust REM
        bra.s   divrts
zerodiv clr.l   d0              ; Divide by zero:
        move.l  #$7fffffff,d1   ;  QUO=infinity, REM=0
divrts  tst.b   d4              ; Need to negate quotient?
        bge.s   quook
        neg.l   d1
quook   tst.w   d4              ; Need to negate remainder?
        bge.s   remok
        neg.l   d0
remok   move.l  d1,32(sp)
        move.l  d0,28(sp)
        movem.l (sp)+,d0-d4
        rts
        
        end
        ident PASMATHB
        
        global  %U_DIV4,%U_MOD4
        
;
; %U_DIV4 - Unsigned integer divide
;
; %U_MOD4 - Unsigned integer modulus
;
; Parameters: ST.L - First arg
;             ST.L - Second arg
;
; Returns: ST.L - The Answer
;
; All registers are preserved.
;

%U_DIV4
        jsr     dodiv
        move.l  (sp)+,(sp)
        rts
        
%U_MOD4
        jsr     dodiv
        move.l  4(sp),8(sp)
        move.l  (sp)+,(sp)
        rts
        
dodiv   movem.l d0-d4,-(sp)
        move.l  28(sp),d0       ; D0 = divisor
        move.l  32(sp),d1       ; D1 = dividend
        clr.l   d2              ; D2 = remainder
        clr.l   d3              ; D3 = quotent
        moveq   #31,d4          ; D4 = loop counter
loop    lsl.l   #1,d2
        roxl.l  #1,d1
        roxl.l  #1,d3
        cmp.l   d0,d3
        blt.s   test
        sub.l   d0,d3
        addq.l  #1,d2
test    dbra    d4,loop
        move.l  d3,28(sp)       ; Store remainder
        move.l  d2,32(sp)       ; Store quotent
        movem.l (sp)+,d0-d4
        rts
        
        end

                                                                                                                                                                                                                                                                                                                                                                                        