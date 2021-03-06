; File: utexto.text
; Date: 08-Nov-83

        UPPER
        IDENT   IDTEXTO
        
        GLOBAL  %W_LN,%W_I,%W_B,%W_S,%W_P,%_PAGE
        EXTERN  %_FLUSH,%_PUTCH,%_WRTIT
        
;
; FIB record offsets
;

BUFFED  EQU     16
IORES   EQU     26

;
; TERMWR - Terminate a Pascal write.  Flush buffer if file is not buffered
;
; Parameters:  A0.L - Address of output file
;
; Saves all registers.
;

TERMWR  
        TST.B   BUFFED(A0)      ; Is file buffered?
        BNE.S   FISBUF          ; Branch around flush if buffered
        JSR     %_FLUSH
FISBUF  RTS

;
; %W_LN - WRITELN
;
; Parameters:  ST.L - Address of output file
;

%W_LN
        MOVE.L  4(SP),A0        ; Pop file address
        MOVE.W  #0,IORES(A5)    ; Clear IORESULT before doing I/O
        JSR     %_WRTIT         ; Set file up for writing
        MOVEQ   #10,D0          ; Get a <LF>
        JSR     %_PUTCH         ; Put character into the file
        BSR.S   TERMWR
        MOVE.L  (SP)+,(SP)      ; Position return address
        RTS

;
; %W_S - WRITE STRING
;
; Parameters:  ST.L - Address of output file
;              ST.L - Address of string
;              ST.W - Size of field to print
;
; Scratches:   D0,D1,D2
;

%W_S
        MOVE.L  (SP)+,D0
        MOVE.W  (SP)+,D1
        MOVE.L  (SP)+,A1
        MOVE.L  (SP)+,A0
        MOVE.L  D0,-(SP)        ; Position return address
        MOVE.W  #0,IORES(A5)    ; Clear IORESULT before doing I/O
        JSR     %_WRTIT         ; Set file up for writing
        CLR.W   D2
        MOVE.B  (A1)+,D2        ; Get string size
        SUB.W   D2,D1           ; Check for xtra blanks
        BLE.S   S_TEST2
        MOVEQ   #' ',D0
S_LOOP  JSR     %_PUTCH
        SUBQ.W  #1,D1
        BNE.S   S_LOOP
        BRA.S   S_TEST2
S_LOOP2 MOVE.B  (A1)+,D0
        JSR     %_PUTCH
S_TEST2 SUBQ.W  #1,D2
        BPL.S   S_LOOP2
        BSR     TERMWR
        RTS

;
; %W_P - WRITE PACKED ARRAY OF CHARACTER
;
; Parameters:  ST.L - Address of output file
;              ST.L - Address of string
;              ST.W - Acutal length
;              ST.W - Size of field to print
;
; Scratches:   D0,D1,D2
;

%W_P
        MOVE.L  (SP)+,D0
        MOVE.W  (SP)+,D1
        MOVE.W  (SP)+,D2
        MOVE.L  (SP)+,A1
        MOVE.L  (SP)+,A0
        MOVE.L  D0,-(SP)        ; Position return address
        MOVE.W  #0,IORES(A5)    ; Clear IORESULT before doing I/O
        JSR     %_WRTIT         ; Set file up for writing
        TST.W   D1              ; Field width > 0?
        BLE.S   P_DONE          ; No. Return
        CMP.W   D2,D1           ; Any extra blanks?
        BLE.S   P_LOOP2         ; No.
        SUB.W   D2,D1           ; Yes. D1 = xtra blanks
        MOVEQ   #' ',D0
P_LOOP  JSR     %_PUTCH
        SUBQ.W  #1,D1
        BNE.S   P_LOOP
        MOVE.W  D2,D1
P_LOOP2 MOVE.B  (A1)+,D0
        JSR     %_PUTCH
        SUBQ.W  #1,D1
        BGT.S   P_LOOP2
P_DONE  JSR     TERMWR
        RTS

;
; %W_I - WRITE INTEGER
;
; Parameters:  ST.L - Address of output file
;              ST.L - Value to print
;              ST.W - Size of field
;
; Scratches:   D0,D1,D2,A0
;

%W_I
        movem.l d3-d6,-(sp)
        move.w  20(sp),d1
        move.l  22(sp),d0
        move.l  26(sp),a0
        move.w  #0,IORES(a5)    ; Clear IORESULT before doing I/O
        JSR     %_WRTIT         ; Set file up for writing
        clr.w   d2              ; # of chars on stack
        move.l  d0,d6
        bge.s   i_pos
        neg.l   d0
i_pos   move.l  d0,d3
i_loop  move.l  d3,d4
        clr.w   d4
        swap    d4              ; D4 = 0000 MSHV
        divu    #10,d4          ; D4 = MSHR MSHQ
        move.l  d4,d5           ; D5 = MSHR MSHQ
        move.w  d3,d5           ; D5 = MSHR LSHV
        divu    #10,d5          ; D5 = REMN LSHQ
        swap    d4              ; D4 = MSHQ MSHR
        move.l  d4,d3           ; D3 = MSHQ MSHR
        move.w  d5,d3           ; D3 = MSHQ LSHQ
        swap    d5
        addi.w  #'0',d5
        move.w  d5,-(sp)
        addq.w  #1,d2
        tst.l   d3
        bne.s   i_loop
        tst.l   d6
        bge.s   i_pos2
        addq.w  #1,d2
        move.w  #'-',-(sp)
i_pos2  move.w  d1,d3
        sub.w   d2,d3
        ble.s   i_loop3
i_loop2 moveq   #' ',d0
        jsr     %_putch
        subq.w  #1,d3
        bgt.s   i_loop2
i_loop3 move.w  (sp)+,d0
        jsr     %_putch
        subq.w  #1,d2
        bgt.s   i_loop3
        jsr     termwr
        movem.l (sp)+,d3-d6
        move.l  (sp)+,a0
        adda.w  #10,sp
        jmp     (a0)

;
; %W_B - WRITE BOOLEAN
;
; Parameters:  ST.L - Address of output file
;              ST.B - Value to print
;              ST.W - Size of field
;
; Scratches: D0,D1,A0
;

%W_B
        move.l  (sp)+,a0
        move.w  (sp)+,d0        ; Size of field
        move.b  (sp)+,d1        ; Value to print
        beq.s   b_false
        subq.b  #1,d1           ; See if it was a 1
        beq.s   b_true
        pea     c_undef         ; Print 'UNDEF'
        bra.s   b_goon
b_true  pea     c_true          ; Print 'TRUE'
        bra.s   b_goon
b_false pea     c_false         ; Print 'FALSE'
b_goon  move.w  d0,-(sp)
        move.l  a0,-(sp)
        jmp     %W_S

c_false data.b  5,70,65,76,83,69        ; 5,'FALSE'
c_true  data.b  4,84,82,85,69,0         ; 4,'TRUE'
c_undef data.b  5,85,78,68,69,70        ; 5,'UNDEF'

;
;
; %_PAGE - PAGE
;
; Parameters:  ST.L - Address of output file
;
; Scratches: D0,A0,A1
;

%_PAGE
        move.l  (sp)+,a1        ; Pop return address
        move.l  (sp)+,a0        ; Pop file address
        move.w  #0,IORES(a5)    ; Clear IORESULT before doing I/O
        jsr     %_wrtit         ; Set file up for writing
        moveq   #12,d0          ; ASCII FF
        move.l  a1,-(sp)
        jsr     %_putch
        jsr     termwr
        rts
        
        end
        
        IDENT IDTEXTO2
        
        GLOBAL  %W_C
        EXTERN  %_FLUSH,%_PUTCH,%_WRTIT
        
;
; FIB record offsets
;

BUFFED  EQU     16
IORES   EQU     26

        
;
; %W_C - Display a character on the CRT
;
; Parameters:  ST.L - Address of output file
;              ST.B - Character to be output
;              ST.W - Size of field to print
;
; Scratches:   D1,D2
;

%W_C
        MOVE.L  (SP)+,A1
        MOVE.W  (SP)+,D2
        MOVE.B  (SP)+,D1
        MOVE.L  (SP)+,A0
        MOVE.W  #0,IORES(A5)    ; Clear IORESULT before doing I/O
        JSR     %_WRTIT         ; Set file up for writing
        BRA.S   WC_TEST
WC_LOOP MOVEQ   #' ',D0
        JSR     %_PUTCH
WC_TEST SUBQ.W  #1,D2
        BGT.S   WC_LOOP
        MOVE.B  D1,D0
        JSR     %_PUTCH
        TST.B   BUFFED(A0)      ; Is file buffered?
        BNE.S   FISBUF          ; Branch around flush if buffered
        JSR     %_FLUSH
FISBUF  JMP     (A1)

        END


                                                                                                                                                                                                                                                                                                                                                                                                                    