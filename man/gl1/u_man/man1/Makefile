# @(#)$Header: /d2/3.7/src/man/gl1/u_man/man1/RCS/Makefile,v 1.1 89/03/27 16:33:03 root Exp $
# $Log:	Makefile,v $
# Revision 1.1  89/03/27  16:33:03  root
# Initial check-in for 3.7
# 

M	= u
S	= 1

all clean clobber:

install:
	-cp *.$Sd $(DEST)/usr/man/$M_man/man$S
	-cd $(DEST)/usr/man/$M_man/man$S;chmod 644 *.$Sd
	-cd $(DEST)/usr/man/$M_man/man$S;chgrp bin *.$Sd;chown bin *.$Sd

FRC:
