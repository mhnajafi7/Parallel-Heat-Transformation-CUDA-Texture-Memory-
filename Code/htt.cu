//ONLY MODIFY THIS FILE!
//YOU CAN MODIFY EVERYTHING IN THIS FILE!

#include "htt.h"

#define tx threadIdx.x
#define bx blockIdx.x

#define tilex 1
#define tiley 1


// you may define other parameters here!
// you may define other macros here!
// you may define other functions here!

//-----------------------------------------------------------------------------
__global__ void kernelFunc(const float* oldtemperature,float* newtemperature, const unsigned int N, const unsigned int M)
{

	int x = tx + bx * blockDim.x;
	int offset = x;

	int right = offset + 1;
	int left  = offset - 1;
	if(x == 0)	left++;
	if(x == N - 1)	right--;

	
	newtemperature[offset] = oldtemperature[offset] + k_const * (oldtemperature[left] + oldtemperature[right] - 2 * oldtemperature[offset] );
}

void gpuKernel(const float* ad,float* cd, const unsigned int N, const unsigned int M){

	kernelFunc<<< (16),(1024) >>>(ad , cd, N, M);

}
