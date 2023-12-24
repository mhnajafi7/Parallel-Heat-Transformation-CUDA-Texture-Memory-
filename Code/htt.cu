#include "htt.h"

#define tx threadIdx.x
#define bx blockIdx.x
#define ty threadIdx.y
#define by blockIdx.y
#define tl 16

//-----------------------------------------------------------------------------
__global__ void kernelFunc(float* newtemperature, const float* oldtemperature, const unsigned int N)
{
    int col = tx + bx * tl;
    int row = ty + by * tl;
    int index = col + row * blockDim.x * gridDim.x;


	int left = index - 1;
    int right = index + 1;
    if (col == 0) left++;
    if (col == N-1) right--;

    int top = index - N;
    int bottom = index + N;
    if (row == 0) top += N;
    if (row == N-1) bottom -= N;

    float r = tex1Dfetch(texref,right);
	float l = tex1Dfetch(texref,left);
	float c = tex1Dfetch(texref,index);
    float t = tex1Dfetch(texref,top);
    float b = tex1Dfetch(texref,bottom);
	// using texture memory
	 newtemperature[index] = c + k_const * (r + l + t + b - 4 * c);

	// linear mode 
	//newtemperature[index] = oldtemperature[index] + k_const * (oldtemperature[left] + oldtemperature[right] + oldtemperature[top] + oldtemperature[bottom]- 4 * oldtemperature[index] );

}

void gpuKernel(const float* ad, float* cd, const unsigned int N, const unsigned int M)
{
    dim3 blockSize(tl, tl);  // Adjust block size as needed
    dim3 gridSize((N+tl-1)/tl, (N+tl-1)/tl);

    cudaBindTexture(NULL, texref, ad, N * N * sizeof(float));

    kernelFunc<<<gridSize, blockSize>>>(cd, ad, N);
}
