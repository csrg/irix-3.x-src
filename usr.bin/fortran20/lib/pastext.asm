; File: pastext.text
; Date: 08-Nov-83

        ident   pastext
        
        global  %W_2,%W_2SF,%W_2SFL,%W_2S_,%W_2S_L
        global  %W_CSF,%W_CSFL,%W_CS_L
        global  %W_ISF,%W_ISFL,%W_IS_,%W_IS_L
        global  %W_SSF,%W_SSFL,%W_SS_,%W_SS_L
        
        extern  %W_LN,%W_C,%W_I,%W_S
        
;
; %W_2 - Write a 2 byte integer
;
; Parameters:  ST.L - Address of output file
;              ST.W - Value to be output
;              ST.W - Size of field to print
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_2
        move.l  (sp)+,d0
        move.w  (sp)+,d1
        move.w  (sp)+,d2
        ext.l   d2
        move.l  d2,-(sp)
        move.w  d1,-(sp)
        move.l  d0,-(sp)
        jmp     %W_I

;
; %W_2SF - Write a 2 byte integer, default size and file
;
; Parameters:  ST.W - Value to be output
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_2SF
        move.l  (sp)+,d0
        move.w  (sp)+,d1
        ext.l   d1
        move.l  12(a5),-(sp)
        move.l  d1,-(sp)
        clr.w   -(sp)
        move.l  d0,-(sp)
        jmp     %W_I
        
;
; %W_2SFL - Writeln a 2 byte integer, default size and file
;
; Parameters:  ST.W - Value to be output
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_2SFL
        move.l  (sp)+,d0
        move.w  (sp)+,d1
        ext.l   d1
        move.l  12(a5),-(sp)
        move.l  d0,-(sp)
        move.l  12(a5),-(sp)
        move.l  d1,-(sp)
        clr.w   -(sp)
        jsr     %W_I
        jmp     %W_LN
        
;
; %W_2S_ - Write a 2 byte integer, default size
;
; Parameters:  ST.L - Address of file
;              ST.W - Value to be output
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_2S_
        move.l  (sp)+,d0
        move.w  (sp)+,d1
        ext.l   d1
        move.l  d1,-(sp)
        clr.w   -(sp)
        move.l  d0,-(sp)
        jmp     %W_I
        
;
; %W_2S_L - Writeln a 2 byte integer, default size
;
; Parameters:  ST.L - Address of file
;              ST.W - Value to be output
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_2S_L
        move.l  (sp)+,d0
        move.w  (sp)+,d1
        ext.l   d1
        move.l  (sp),d2
        move.l  d0,-(sp)
        move.l  d2,-(sp)
        move.l  d1,-(sp)
        clr.w   -(sp)
        jsr     %W_I
        jmp     %W_LN
        
;
; %W_CSF - Write a character, default size and file
;
; Parameters:  ST.B - Value to be output
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_CSF
        move.l  (sp)+,d0
        move.b  (sp)+,d1
        move.l  12(a5),-(sp)
        move.b  d1,-(sp)
        move.w  #1,-(sp)
        move.l  d0,-(sp)
        jmp     %W_C
        
;
; %W_CSFL - Writeln a character, default size and file
;
; Parameters:  ST.B - Value to be output
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_CSFL
        move.l  (sp)+,d0
        move.b  (sp)+,d1
        move.l  12(a5),-(sp)
        move.l  d0,-(sp)
        move.l  12(a5),-(sp)
        move.b  d1,-(sp)
        move.w  #1,-(sp)
        jsr     %W_C
        jmp     %W_LN
        
;
; %W_CS_L - Writeln a character, default size
;
; Parameters:  ST.L - Address of file
;              ST.B - Value to be output
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_CS_L
        move.l  (sp)+,d0
        move.b  (sp)+,d1
        move.l  (sp),d2
        move.l  d0,-(sp)
        move.l  d2,-(sp)
        move.b  d1,-(sp)
        move.w  #1,-(sp)
        jsr     %W_C
        jmp     %W_LN
        
;
; %W_ISF - Write an integer, default size and file
;
; Parameters:  ST.L - Value to be output
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_ISF
        move.l  (sp)+,d0
        move.l  (sp)+,d1
        move.l  12(a5),-(sp)
        move.l  d1,-(sp)
        clr.w   -(sp)
        move.l  d0,-(sp)
        jmp     %W_I
        
;
; %W_ISFL - Writeln an integer, default size and file
;
; Parameters:  ST.L - Value to be output
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_ISFL
        move.l  (sp)+,d0
        move.l  (sp)+,d1
        move.l  12(a5),-(sp)
        move.l  d0,-(sp)
        move.l  12(a5),-(sp)
        move.l  d1,-(sp)
        clr.w   -(sp)
        jsr     %W_I
        jmp     %W_LN
        
;
; %W_IS_ - Write an integer, default size
;
; Parameters:  ST.L - Address of file
;              ST.L - Value to be output
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_IS_
        move.l  (sp)+,d0
        clr.w   -(sp)
        move.l  d0,-(sp)
        jmp     %W_I
        
;
; %W_IS_L - Writeln an integer, default size
;
; Parameters:  ST.L - Address of file
;              ST.L - Value to be output
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_IS_L
        move.l  (sp)+,d0
        move.l  (sp)+,d1
        move.l  (sp),d2
        move.l  d0,-(sp)
        move.l  d2,-(sp)
        move.l  d1,-(sp)
        clr.w   -(sp)
        jsr     %W_I
        jmp     %W_LN
        
;
; %W_SSF - Write a string, default size and file
;
; Parameters:  ST.L - Address of string
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_SSF
        move.l  (sp)+,d0
        move.l  (sp)+,d1
        move.l  12(a5),-(sp)
        move.l  d1,-(sp)
        clr.w   -(sp)
        move.l  d0,-(sp)
        jmp     %W_S
        
;
; %W_SSFL - Writeln a string, default size and file
;
; Parameters:  ST.L - Address of string
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_SSFL
        move.l  (sp)+,d0
        move.l  (sp)+,d1
        move.l  12(a5),-(sp)
        move.l  d0,-(sp)
        move.l  12(a5),-(sp)
        move.l  d1,-(sp)
        clr.w   -(sp)
        jsr     %W_S
        jmp     %W_LN
        
;
; %W_SS_ - Write a string, default size
;
; Parameters:  ST.L - Address of file
;              ST.L - Sddress of string
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_SS_
        move.l  (sp)+,d0
        clr.w   -(sp)
        move.l  d0,-(sp)
        jmp     %W_S
        
;
; %W_SS_L - Writeln a string, default size
;
; Parameters:  ST.L - Address of file
;              ST.L - Sddress of string
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_SS_L
        move.l  (sp)+,d0
        move.l  (sp)+,d1
        move.l  (sp),d2
        move.l  d0,-(sp)
        move.l  d2,-(sp)
        move.l  d1,-(sp)
        clr.w   -(sp)
        jsr     %W_S
        jmp     %W_LN
        
        end
        
        ident   pastxt2
        
        global  %W_CS_
        extern  %W_C
        
;
; %W_CS_ - Write a character, default size
;
; Parameters:  ST.L - Address of file
;              ST.B - Value to be output
;
; Scratches:   D0,D1,D2,A0,A1
;

%W_CS_
        move.l  (sp)+,d0
        move.w  #1,-(sp)
        move.l  d0,-(sp)
        jmp     %W_C
        
        end

                                                                                                                                                                                                                                                          