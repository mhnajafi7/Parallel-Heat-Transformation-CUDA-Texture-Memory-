#include "htt.h"

#define tx threadIdx.x
#define bx blockIdx.x
#define ty threadIdx.y
#define by blockIdx.y

#define cst 16      // Define a constant value

// Define a texture memory
texture<float,cudaTextureType1D,cudaReadModeElementType> texref;

__global__ void kernelFunc(float* newtemperature, const float* oldtemperature, const unsigned int N)
{   
    // Calculate column and row indices based on thread and block indices
    int col = tx + bx * cst;
    int row = ty + by * cst;
    int index = col + row * blockDim.x * gridDim.x;

    // Calculate indices for neighboring elements
	int left = index - 1;
    int right = index + 1;
    if (col == 0) left++;
    if (col == N-1) right--;

    int top = index - N;
    int bottom = index + N;
    if (row == 0) top += N;
    if (row == N-1) bottom -= N;

    // Fetch values from texture memory for neighboring elements
    float r = tex1Dfetch(texref,right);
	float l = tex1Dfetch(texref,left);
	float c = tex1Dfetch(texref,index);
    float t = tex1Dfetch(texref,top);
    float b = tex1Dfetch(texref,bottom);
    
	// Calculate the new temperature using texture memory
	newtemperature[index] = c + k_const * (r + l + t + b - 4 * c);

	/*
    // Calculate the new temperature not texture memory
    newtemperature[index] = oldtemperature[index] + k_const * (oldtemperature[left] + oldtemperature[right] + oldtemperature[top] + oldtemperature[bottom]- 4 * oldtemperature[index] );
    */

}

void gpuKernel(float* ad, float* cd, const unsigned int N, const unsigned int M)
{

    // Define block size and grid size
    dim3 blockSize(cst, cst);  // Adjust block size as needed
    dim3 gridSize(N/cst, N/cst);

    // Bind the texture to the input data on GPU memory
    cudaBindTexture(NULL, texref, ad, N * N * sizeof(float));

    // Launch the CUDA kernel function
    kernelFunc<<<gridSize,blockSize>>>(cd, ad, N);

    // Unbind the texture after kernel execution
    cudaUnbindTexture(texref);

}
