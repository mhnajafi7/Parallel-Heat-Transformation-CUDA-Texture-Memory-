//ONLY MODIFY THIS FILE!
//YOU CAN MODIFY EVERYTHING IN THIS FILE!

#include "htt.h"

#define tx threadIdx.x
#define ty threadIdx.y
#define tz threadIdx.z

#define bx blockIdx.x
#define by blockIdx.y
#define bz blockIdx.z

// you may define other parameters here!
// you may define other macros here!
// you may define other functions here!

//-----------------------------------------------------------------------------
void gpuKernel(float* temperature, const unsigned int N, const unsigned int M)
{
	int x = threadIdx.x + blockIdx.x * blockDim.x;
	
	int offset = x;

	int right = offset + 1;
	int left  = offset - 1;

	if(x == 0)	left++;
	if(x == DIM - 1)	right--;

}
