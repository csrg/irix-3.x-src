| C library -- lseek

| error = lseek(file, offset, ptr);
| long offset
| long lseek()

include(../DEFS.m4)

ENTRY(lseek)
	moveq	#19,d0
	movl	sp@(4),a0	| fetch argument
	movl	sp@(8),d1	| fetch argument
	movl	sp@(12),a1	| fetch argument
	trap	#0
	jcs	1$
	rts

1$:	jmp	cerror
