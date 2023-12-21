#include "htt.h"

#define tx threadIdx.x
#define bx blockIdx.x
#define ty threadIdx.y
#define by blockIdx.y
#define tl 16

//-----------------------------------------------------------------------------
/*__global__ void kernelFunc(float* cd, const float* ad, const unsigned int n)
{
   // int row = by * tl+ ty;
    //int col = bx * tl + tx;

   // cd[0] =ad[0];
    //cd[row*n + col] =ad[0];
}*/

void gpuKernel(float* ad, const unsigned int N, const unsigned int M)
{
    //dim3 blockSize(tl, tl);  // Adjust block size as needed
    //dim3 gridSize(N/tl, N/tl);

    //kernelFunc<<<gridSize, blockSize>>>(cd, ad, N);


}
