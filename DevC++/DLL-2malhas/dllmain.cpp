/* Replace "dll.h" with the name of your header */
#include "dll.h"
#include <windows.h>

#include <math.h>
#include <stdio.h>


// Variables:
//      t: Time, passed from PSIM by value
//   delt: Time step, passed from PSIM by value
//     in: input array, passed from PSIM by reference
//    out: output array, sent back to PSIM (Note: the values of out[*] can
//         be modified in PSIM)

// The maximum length of the input and output array "in" and "out" is 30.

double t, delt;
double *in, *out;

// PI da Malha de corrente
double  a0zi = 1.00000000e+00;
double  a1zi = -1.00000000e+00;
double  b0zi = 5.30305662e-05;
double  b1zi = -4.65043351e-05;

// PI da Malha de tensão
double  a0zv = 1.00000000e+00;
double  a1zv = -1.00000000e+00;
double  b0zv = 5.30305662e-05;
double  b1zv = -4.65043351e-05;



__stdcall void simuser (double t, double delt, double *in, double *out)
{
// Place your code here............begin


//  Define "sum" as "static" in order to retain its value.
	static double e0i=0,e1i=0,u0i=0,u1i=0; // PI da Malha de corrente
	static double e0v=0,e1v=0,u0v=0,u1v=0; // PI da Malha de tensão
	
	e0i=in[0]; // Erro atual

    u0i= (e0i*b0zi+e1i*b1zi-u1i*a1zi)/a0zi;
    u1i=u0i;
    e1i=e0i;
    
	out[0] = u0i;


// Place your code here............end
}



