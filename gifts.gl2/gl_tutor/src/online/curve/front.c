#include "curve.h"

init_front(n)
/*---------------------------------------------------------------------------
 * Open window n.
 *---------------------------------------------------------------------------
 */
int n;
{
    int res;
    

    switch(n){
    case DOWNZ:
	prefposition(480, 840, 5, 365);
	res = winopen("Z");
	wintitle("Curve -- VIEW DOWN Z-AXIS");
	keepaspect(1, 1);
	winconstraints();
	perspective(450, 1.0, 1.0, 30.0);
	lookat(.5, .5, 3.0, 0.0, 0.0, 0.0, 0);
	break;
    case DOWNY:
	prefposition(85, 335, 25, 275);
	res = winopen("Y");
	wintitle("Curve -- VIEW DOWN Y-AXIS");
	keepaspect(1, 1);
	winconstraints();
	perspective(450, 1.0, 1.0, 30.0);
	lookat(.5, 3.0, .5, 0.0, 0.0, 0.0, 1350);
	break;
    case DOWNX:
	prefposition(85, 335, 325, 575);
	res = winopen("X");
	wintitle("Curve -- VIEW DOWN X-AXIS");
	keepaspect(1, 1);
	winconstraints();
	perspective(450, 1.0, 1.0, 30.0);
	lookat(3.0, .5, .5, 0.0, 0.0, 0.0, 0);
	break;
    }

    return(res);
}

redraw_front(n)
/*---------------------------------------------------------------------------
 * Redraw the n front window.
 *---------------------------------------------------------------------------
 */
int n;
{

    attach_to_front(n);
    reshapeviewport();

    if (n == frontxw)
	draw_front(DOWNX);
    else if (n == frontyw)
	draw_front(DOWNY);
    else if(n == frontzw)
	draw_front(DOWNZ);

    swapbuffers();

    if (n == frontxw)
	draw_front(DOWNX);
    else if (n == frontyw)
	draw_front(DOWNY);
    else if(n == frontzw)
	draw_front(DOWNZ);
}

draw_fronts()
/*---------------------------------------------------------------------------
 * Draw the three views of the curve.
 *---------------------------------------------------------------------------
 */
{
    register int i;

    curvebasis(curbasis);
    curveprecision(curprec);

    makeobj(CURVE);
	draw_curve();
    closeobj();

    for (i = 0 ; i < NUMVIEWS ; i++){
	attach_to_front(i);		/* Chose a view.		*/
	reshapeviewport();
	color(BLACK);
	clear();
	callobj(CURVE);
    }
}

draw_front(n)
/*---------------------------------------------------------------------------
 * Draw the nth view of the curve.
 *---------------------------------------------------------------------------
 */
{
    curvebasis(curbasis);
    curveprecision(curprec);

    makeobj(CURVE);
	draw_curve();
    closeobj();

    attach_to_front(n);		/* Chose a view.		*/
    reshapeviewport();
    color(BLACK);
    clear();
    callobj(CURVE);
}

setup_front_environ(n)
/*---------------------------------------------------------------------------
 * Setup the environment for the front view n.
 *---------------------------------------------------------------------------
 */
int n;
{
    reshapeviewport();

    switch(n){
    case DOWNZ:
	loadmatrix(downz);
	break;
    case DOWNY:
	loadmatrix(downy);
	break;
    case DOWNX:
	loadmatrix(downx);
	break;
    }
}

attach_to_front(n)
/*---------------------------------------------------------------------------
 * Attach to the front view n for the curve.
 *---------------------------------------------------------------------------
 */
int n;
{
    switch(n){
    case DOWNZ:
	winset(frontzw);
	break;    
    case DOWNY:
	winset(frontyw);
	break;
    case DOWNX:
	winset(frontxw);
	break;
    }
}

draw_curve()
/*---------------------------------------------------------------------------
 * Draw a curve with the current basis and control points.
 *---------------------------------------------------------------------------
 */
{
    draw_axis();
    color(OBJECTCOLOR);
    crv(curgeom);
    draw_control_points();
}

draw_control_points()
/*---------------------------------------------------------------------------
 * Draw the control points in different colors with numbers by them.
 *---------------------------------------------------------------------------
 */
{
    int i;

    color(NORMCOLOR);
    for (i = 0 ; i < 4 ; i++)
	if (i != curcont)
	    draw_control_point(i);

    if ((curcont > NONE) && (curcont < NUMPNTS)){
	color(HIGHCOLOR);
	draw_control_point(curcont);
    }
}

draw_axis()
/*---------------------------------------------------------------------------
 * Draw the x, y and z-axis in three different colors.
 *---------------------------------------------------------------------------
 */
{
    color(AXESCOLOR);
    arrow(0.0, 0.0, 0.0, 1.0, 0.0, 0.0);
    arrow(0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    arrow(0.0, 0.0, 0.0, 0.0, 0.0, 1.0);

    color(UNPICKCOLOR);
    cmov(1.1, 0.0, 0.0);
    charstr("X");
    cmov(0.0, 1.1, 0.0);
    charstr("Y");
    cmov(0.0, 0.0, 1.1);
    charstr("Z");
}


arrow(x1, y1, z1, x2, y2, z2)
/*---------------------------------------------------------------------------
 * Draw an arrow from here to there.
 *---------------------------------------------------------------------------
 */
Coord x1, y1, z1, x2, y2, z2;
{
    float dx, dy, dz;

    dx = (x2-x1)/20.0;
    dy = (y2-y1)/20.0;
    dz = (z2-z1)/20.0;

    line(x1, y1, z1, x2, y2, z2);

    if (dx != 0.0){
	pmv(x2-dx, y2+dx, z2);
	pdr(x2-dx, y2-dx, z2);
	pdr(x2, y2, z2);
	pclos();
	pmv(x2, y2, z2);
	pdr(x2-dx, y2, z2+dx);
	pdr(x2-dx, y2, z2-dx);
	pclos();
    }

    if (dy != 0.0){
	pmv(x2, y2, z2);
	pdr(x2+dy, y2-dy, z2);
	pdr(x2-dy, y2-dy, z2);
	pclos();
	pmv(x2, y2, z2);
	pdr(x2, y2-dy, z2-dy);
	pdr(x2, y2-dy, z2+dy);
	pclos();
    }

    if (dz != 0.0){
	pmv(x2, y2, z2);
	pdr(x2-dz, y2, z2-dz);
	pdr(x2+dz, y2, z2-dz);
	pclos();
	pmv(x2, y2, z2);
	pdr(x2, y2-dz, z2-dz);
	pdr(x2, y2+dz, z2-dz);
	pclos();
    }
}

lpnt(x, y, z)
/*---------------------------------------------------------------------------
 * Draw a line that is a point to keep the linestyle preserved.
 *---------------------------------------------------------------------------
 */
Coord x, y, z;
{
    pushmatrix();
	translate(x, y, z);
	circf(0.0, 0.0, .01);
    popmatrix();
}

draw_control_point(i)
/*---------------------------------------------------------------------------
 * Draw the control point i.
 *---------------------------------------------------------------------------
 */
{
    char buf[3];

    lpnt(curgeom[i][X], curgeom[i][Y], curgeom[i][Z]);
    cmov(curgeom[i][X]+.02, curgeom[i][Y]+.02, curgeom[i][Z]+.02);
    sprintf(buf, "%d", i);
    charstr(buf);
}

handle_control(pnt)
/*---------------------------------------------------------------------------
 * Handle a hit on control point pnt.
 *---------------------------------------------------------------------------
 */
{
    if ((pnt > NONE) && (pnt < NUMPNTS) || (pnt == PRECISION))
        curcont = pnt;
}

pick_control()
/*---------------------------------------------------------------------------
 * Attach to and check the curve for a picking hit.
 *---------------------------------------------------------------------------
 */
{
    int i;

    attach_to_front(DOWNZ);

        pushmatrix();
        pick(pick_buffer, MAXPICK);
	    loadmatrix(downz);
	    initnames();
	    pushname(CONTROL);
	    for (i = 0 ; i < NUMPNTS ; i++){
		pushname(i);
		draw_control_point(i);
		popname();
	    }
	retnumber = endpick(pick_buffer);
    popmatrix();

    if (retnumber != 0)
	return(1);

    attach_to_front(DOWNX);

        pushmatrix();
        pick(pick_buffer, MAXPICK);
	    loadmatrix(downx);
	    initnames();
	    pushname(CONTROL);
	    for (i = 0 ; i < NUMPNTS ; i++){
		pushname(i);
		draw_control_point(i);
		popname();
	    }
	retnumber = endpick(pick_buffer);
    popmatrix();

    if (retnumber != 0)
	return(1);

    attach_to_front(DOWNY);

        pushmatrix();
        pick(pick_buffer, MAXPICK);
	    loadmatrix(downy);
	    initnames();
	    pushname(CONTROL);
	    for (i = 0 ; i < NUMPNTS ; i++){
		pushname(i);
		draw_control_point(i);
		popname();
	    }
	retnumber = endpick(pick_buffer);
    popmatrix();
}
