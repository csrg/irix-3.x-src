/**************************************************************************
 *									  *
 * 		 Copyright (C) 1984, Silicon Graphics, Inc.		  *
 *									  *
 *  These coded instructions, statements, and computer programs  contain  *
 *  unpublished  proprietary  information of Silicon Graphics, Inc., and  *
 *  are protected by Federal copyright law.  They  may  not be disclosed  *
 *  to  third  parties  or copied or duplicated in any form, in whole or  *
 *  in part, without the prior written consent of Silicon Graphics, Inc.  *
 *									  *
 **************************************************************************/

#include "globals.h"
#include "TheMacro.h"
#include "immatrix.h"

ROOT_MATRIX(loadmatrix)

#include "interp.h"

INTERP_NAME(loadmatrix);

static bogus ()
{
    DECLARE_INTERP_REGS;

    INTERP_ROOT_MATRIX(loadmatrix);
}
