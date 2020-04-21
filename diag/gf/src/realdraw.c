#include "geofdef.h"

unsigned short realdrawsetup[] = {
	 7,			/* clear hit mode */
         5,			/* load vp */
         1,     53120,
         1,     38016,
         1,     52992,
         1,     37888,
         0,     0,
         0,       128,
         0,     0,
         0,     0,

         1,	/* load MM w/ ident. */
       320,     0,
         0,     0,
         0,     0,
         0,     0,
         0,     0,
       320,     0,
         0,     0,
         0,     0,
         0,     0,
         0,     0,
       320,     0,
         0,     0,
         0,     0,
         0,     0,
         0,     0,
       320,     0,
	GEOF
};

unsigned short realdraw[] = {
        36,	/* F mod 0 */
       113,
     29481,
     65191,
      6044,
         0,
         0,
         0,
         0,
        33,
     65112,
     59492,
       113,
     29481,
         0,
         0,
         0,
         0,
        34,
         0,
         0,
         0,
         0,
       115,
     13107,
         0,
         0,
        43,
         0,
         0,
         0,
         0,
         0,
         0,
       320,
         0,

        48,	/* move poly */
         0,
         0,
       326,
     26214,
         0,
         0,
       320,
         0,
        49,	/* draw poly */
       326,
     26214,
         0,
         0,
         0,
         0,
       320,
         0,
        49,	/* draw poly */
         0,
         0,
       441,
     39322,
         0,
         0,
       320,
         0,
        49,	/* draw poly */
       441,
     39322,
         0,
         0,
         0,
         0,
       320,
         0,
        51,	/* close */
	GEOF
};

unsigned short realdots[] = {
	18,	/* point */
	0x100,	0,
	0x100,	0,
	0,	0,
	320,	0,
	18,	/* point */
	0x10f,	0xffff,
	0x100,	0,
	0,	0,
	320,	0,
	18,	/* point */
	0x100,	0,
	0x10f,	0xffff,
	0,	0,
	320,	0,
	18,	/* point */
	0x105,	0x5555,
	0x100,	0,
	0,	0,
	320,	0,
	18,	/* point */
	0x100,	0,
	0x105,	0x5555,
	0,	0,
	320,	0,
	18,	/* point */
	0x102,	0x2222,
	0x100,	0,
	0,	0,
	320,	0,
	18,	/* point */
	0x100,	0,
	0x102,	0x2222,
	0,	0,
	320,	0,
	18,	/* point */
	0x101,	0xcccc,
	0x101,	0x3333,
	0,	0,
	320,	0,
	GEOF
};

unsigned short realpoly[] = {
#ifdef GF2
	0xc08,
	0x30,
	0, 0,
	0x31,
	0x100, 0,
	0x31,
	0x100, 0x100,
	0x31,
	0, 0x100,
#else
	0x1408,
	0x30,
	0, 0, 0, 0,
	0x31,
	1, 0, 0, 0,
	0x31,
	1, 0, 1, 0,
	0x31,
	0, 0, 1, 0,
#endif
	0x33,
	GEOF
};