; File: nan.text
; Date: 29-Jan-85
;

        ident   NAN
        
        global  %_ISNAN,%_ISNUM,%_ISINF,%_ISUNF,%_SGNBT
        global  %_DISNAN,%_DISNUM,%_DISINF,%_DISUNF,%_DSGNBT
        
;
; %_ISNAN - Is real argument a NAN?
;
; Parameters: ST.L - Arg
;
; Returns:    D0.L - The answer
;
; Scratches:  D0
;

%_ISNAN
        move.l  4(sp),d0
        bclr    #31,d0          ; Clear sign bit
        cmpi.l  #$7F800000,d0
        sgt     d0
        andi.l  #1,d0
        move.l  (sp)+,(sp)
        rts
        
;
; %_ISNUM - Is real argument a valid number?
;
; Parameters: ST.L - Arg
;
; Returns:    D0.L - The answer
;
; Scratches:  D0
;

%_ISNUM
        move.l  4(sp),d0
        bclr    #31,d0          ; Clear sign bit
        cmpi.l  #$7F800000,d0
        slt     d0
        andi.l  #1,d0
        move.l  (sp)+,(sp)
        rts
        
;
; %_ISINF - Is real argument infinity?
;
; Parameters: ST.L - Arg
;
; Returns:    D0.L - The answer
;
; Scratches:  D0
;

%_ISINF
        move.l  4(sp),d0
        bclr    #31,d0          ; Clear sign bit
        cmpi.l  #$7F800000,d0
        seq     d0
        andi.l  #1,d0
        move.l  (sp)+,(sp)
        rts
        
;
; %_ISUNF - Is real argument underflown?
;
; Parameters: ST.L - Arg
;
; Returns: D0.L - The answer
;
; Scratches: A0
;

%_ISUNF
        move.l  (sp)+,a0
        move.l  (sp)+,d0
        bclr    #31,d0
        tst.l   d0              ; Is it zero?
        beq.s   unfz  
        cmpi.l  #$00800000,d0
        sgt     d0
        andi.l  #1,d0
unfz    jmp     (a0)
        
;
; %_SGNBT - Is real argument negative?
;
; Parameters: ST.L - Arg
;
; Returns: D0.L - The answer
;
; Scratches: A0
;

%_SGNBT
        move.l  (sp)+,a0
        move.l  (sp)+,d0
        rol.l   #1,d0
        andi.l  #1,d0
        jmp     (a0)
        
;
; %_DISNAN - Is double argument a NAN?
;
; Parameters: ST.Q - Arg
;
; Returns:    D0.L - The answer
;
; Scratches:  D0
;

%_DISNAN
        move.l  4(sp),d0
        bclr    #31,d0          ; Clear sign bit
        cmpi.l  #$7FF00000,d0
        blt.s   dfalse
        bgt.s   dtrue
        tst.l   8(sp)
        beq.s   dfalse
dtrue   moveq   #1,d0
        move.l  (sp)+,(sp)
        move.l  (sp)+,(sp)
        rts
dfalse  moveq   #0,d0
        move.l  (sp)+,(sp)
        move.l  (sp)+,(sp)
        rts
        
;
; %_DISNUM - Is double argument a number?
;
; Parameters: ST.Q - Arg
;
; Returns:    D0.L - The answer
;
; Scratches:  D0
;

%_DISNUM
        move.l  4(sp),d0
        bclr    #31,d0          ; Clear sign bit
        cmpi.l  #$7FF00000,d0
        slt     d0
        andi.l  #1,d0
        move.l  (sp)+,(sp)
        move.l  (sp)+,(sp)
        rts
        
;
; %_DISINF - Is double argument infinity?
;
; Parameters: ST.Q - Arg
;
; Returns:    D0.L - The answer
;
; Scratches:  D0
;

%_DISINF
        move.l  4(sp),d0
        bclr    #31,d0          ; Clear sign bit
        cmpi.l  #$7FF00000,d0
        bne.s   difalse
        tst.l   8(sp)
difalse seq     d0
        andi.l  #1,d0
        move.l  (sp)+,(sp)
        move.l  (sp)+,(sp)
        rts
        
;
; %_DISUNF - Is double argument underflown?
;
; Parameters: ST.Q - Arg
;
; Returns: D0.L - The answer
;
; Scratches: A0
;

%_DISUNF
        move.l  (sp)+,a0
        move.l  (sp)+,d0
        bclr    #31,d0
        tst.l   d0
        bne.s   dunfnz
        tst.l   (sp)
        beq.s   dunfz
dunfnz  cmpi.l  #$00100000,d0
dunfz   slt     d0
        andi.l  #1,d0
        addq.w  #4,sp
        jmp     (a0)
        
;
; %_DSGNBT - Is double argument negative?
;
; Parameters: ST.Q - Arg
;
; Returns: D0.L - The answer
;
; Scratches: A0
;

%_DSGNBT
        move.l  (sp)+,a0
        move.l  (sp)+,d0
        rol.l   #1,d0
        andi.l  #1,d0
        addq.w  #4,sp
        jmp     (a0)
        
        end

                                                                                                                                                                                                                                                                                                                                    