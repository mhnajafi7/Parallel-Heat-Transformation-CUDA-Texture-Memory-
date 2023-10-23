//ONLY MODIFY THIS FILE!
//YOU CAN MODIFY EVERYTHING IN THIS FILE!

#include "htt.h"

#define tx threadIdx.x


#define bx blockIdx.x

// you may define other parameters here!
// you may define other macros here!
// you may define other functions here!
/*dim3 getDimGrid(const int m, const int n) {
        dim3 dimGrid(1);
        return dimGrid;
}
dim3 getDimBlock(const int m, const int n) {
        dim3 dimBlock(1024);
        return dimBlock;
}*/
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
