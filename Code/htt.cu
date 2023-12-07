#include "htt.h"

#define tx threadIdx.x
#define bx blockIdx.x
#define ty threadIdx.y
#define by blockIdx.y
#define tl N

//-----------------------------------------------------------------------------
__global__ void kernelFunc(float* newtemperature, const float* oldtemperature, const unsigned int N)
{
    int col = tx + bx * tl;
    int row = ty + by * tl;
    int index = row * N + col;

    if (row < N && col < N) {
    newtemperature[index] = oldtemperature[index];
    }
}

void gpuKernel(const float* ad, float* cd, const unsigned int N, const unsigned int M)
{
    dim3 blockSize(tl, tl);  // Adjust block size as needed
    dim3 gridSize((N+tl-1)/tl, (N+tl-1)/tl);

    kernelFunc<<<gridSize, blockSize>>>(cd, ad, N);
}
