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

// Constantes do controlador
double  a0z = 1.00000000e+00;
double  a1z = -1.00000000e+00;
double  b0z = 3.32464639e-03;
double  b1z = 3.32464639e-03;


__stdcall void simuser (double t, double delt, double *in, double *out)
{
// Place your code here............begin


//  Define "sum" as "static" in order to retain its value.
	static double e0=0,e1=0,u0=0,u1=0;
	
	e0=in[0]; // Erro atual
    // Calcula saída atual 
    u0= (e0*b0z+e1*b1z-u1*a1z)/a0z;
    u1=u0; // Atualiza saída anterior
    e1=e0; // Atualiza erro anterior    
	out[0] = u0; // Saída do controlador


// Place your code here............end
}



