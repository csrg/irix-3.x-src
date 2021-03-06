; File: ftn.misc.text
; Date: 29-May-85

;
; Misc. FORTRAN Stuff - By R. Steven Glanville
;

        ident   ftn_misc
        
        global  %_IABS,%_IDIM,%_ISIGN,%_IMOD
        global  %_CONJ
        global  %_MAX,%_MIN
        global  %C_CMP
        global  %C_NEG
        global  %_ABS
        
        extern  %I_MOD4
        extern  %F_CMP
        
;
; function %_IABS(var i: longint): longint;
;
; Integer absolute value
;

%_IABS
        move.l  4(sp),a0
        move.l  (a0),d0
        bpl.s   iabsok
        neg.l   d0
iabsok  move.l  (sp)+,(sp)
        rts
        
;
; function %_IDIM(i,j: longint): longint;
;
; i - j if >= 0, else 0
;

%_IDIM
        move.l  8(sp),d0        ; I
        sub.l   4(sp),d0        ; I - J
        bpl.s   idimok
        clr.l   d0
idimok  move.l  (sp),8(sp)
        addq.l  #8,sp
        rts
        
;
; function %_ISIGN(i,j: longint): longint;
;
; |i| if j >= 0,  -|i| if j < 0
;

%_ISIGN
        move.l  8(sp),d0        ; I
        bpl.s   noabs
        neg.l   d0
noabs   tst.l   4(sp)           ; |I|
        bpl.s   isignok
        neg.l   d0              ; -|I|
isignok move.l  (sp)+,(sp)
        move.l  (sp)+,(sp)
        rts
        
;
; function %_IMOD(i,j: longint): longint;
;
; i - (i/j)*j
;

%_IMOD
        jmp     %I_MOD4
        
;
; function %_CONJ(c: complex): complex;
;

%_CONJ
        movem.l 4(sp),d0/d1
        bchg    #31,d1
        move.l  (sp)+,(sp)
        move.l  (sp)+,(sp)
        rts
        
;
; %_MAX - FORTRAN max(i,j) function
;
; Parameters: ST.L - First param
;             ST.L - Second param
;
; Returns:    D0.L - Result
;
; Scratches: Only D0.
;

%_MAX
        move.l  4(sp),d0        ; J
        cmp.l   8(sp),d0
        bge.s   maxok
        move.l  8(sp),d0
maxok   move.l  (sp)+,(sp)
        move.l  (sp)+,(sp)
        rts
        
;
; %_MIN - FORTRAN min(i,j) function
;
; Parameters: ST.L - First param
;             ST.L - Second param
;
; Returns:    D0.L - Result
;
; Scratches: Only D0.
;

%_MIN
        move.l  4(sp),d0        ; J
        cmp.l   8(sp),d0
        ble.s   minok
        move.l  8(sp),d0
minok   move.l  (sp)+,(sp)
        move.l  (sp)+,(sp)
        rts
        
;
; function %_ABS(var r: real): real;
;
; Real absolute value
;

%_ABS
        move.l  (sp)+,a0
        move.l  (sp)+,d0
        bclr    #31,d0
        jmp     (a0)
        
;
; %C_CMP - Complex compare
;
; Parameters: ST.C - First param
;             ST.C - Second param
;
; Returns: CC - Result
;
; All registers preserved.
;

%C_CMP
        move.l  8(sp),-(sp)     ; Push B.I
        move.l  20(sp),-(sp)    ; Push A.I
        move.l  8(sp),24(sp)    ; Set up return address
        jsr     %F_CMP
        bne.s   ccmpne
        move.l  4(sp),-(sp)     ; Push B.R
        move.l  16(sp),-(sp)    ; Push A.R
        jsr     %F_CMP
ccmpne  adda.w  #16,sp
        rts
        
;
; %C_NEG - Complex negate
;
; Parameters: ST.C - Param
;
; Returns: ST.C - Result
;
; All registers preserved.
;

%C_NEG
        bchg    #7,4(sp)        ; Negate Real part
        bchg    #7,8(sp)        ; Negate Imaginary part
        rts
        
        end

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  