//Do NOT MODIFY THIS FILE

#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>
#include "cstdlib"
#include "ctime"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "iostream"
#include "gputimer.h"
#include "gpuerrors.h"
#include "htt.h"

// ===========================> Functions Prototype <===============================
void fill(float* data, int size);
double calc_mse (float* data1, float* data2, int size);
void cpuKernel(const float* const a,float* c, const int m, const int n);
void gpuKernels(const float* const a, float* c, const int m, const int n, double* gpu_kernel_time);
// =================================================================================

int main(int argc, char** argv) {

    struct cudaDeviceProp p;
    cudaGetDeviceProperties(&p, 0);
    printf("Device Name: %s\n", p.name);
	
	// get parameter from command line to build Matrix dimension
	// check for 10<=m<=13, because m>=14 do not fit in the memory of our GPU, i.e., 1GB.
	int m = atoi(argv[1]);
    int n = (1 << m);
	
	// allocate memory in CPU for calculation
	float* a;
	float* c_serial;
	float* c;
	a        = (float*)malloc(n * sizeof(float));
	c_serial = (float*)malloc(n * sizeof(float));
	c        = (float*)malloc(n * sizeof(float));
	
	// fill a, b matrices with random values between -16.0f and 16.0f
	srand(static_cast<unsigned int>(time(0)));
	fill(a, n);

	// CPU calculations
	clock_t cput1 = clock();
	cpuKernel (a,c_serial, m, n);
	clock_t cput2 = clock();
		
	// GPU calculations
	double gpu_kernel_time = 0.0;
	clock_t t1 = clock(); 
	gpuKernels (a,c, m, n, &gpu_kernel_time);
    clock_t t2 = clock(); 
		
	// check correctness of GPU calculations against CPU
	double mse = 0.0;
	mse += calc_mse( c_serial, c, n );


	printf("m=%d n=%d CPU=%g ms GPU=%g ms GPU-Kernel=%g ms mse=%g\n",
	m, n, (cput2-cput1)/1000.0, (t2-t1)/1000.0, gpu_kernel_time, mse);

	/*for (int i=0; i<n; ++i)
        printf("a=%f c_parallel=%f c_serial=%f\n",a[i],c[i],c_serial[i]);	*/
	// free allocated memory for later use
	free(a);
	free(c_serial);
	free(c);
   
	return 0;
}

void fill(float* data, int size) {

    for (int i=0; i<size; ++i){
        int randomInt = rand();
		float randomFloat = 20.0f +(randomInt / (RAND_MAX + 1.0f)) * 10.0f;
		data[i] = randomFloat;
	}
}

double calc_mse (float* data1, float* data2, int size) {
	double mse = 0.0;
	int i; for (i=0; i<size; i++) {
		double e = data1[i]-data2[i];
		e = e * e;
		mse += e;
	}
	return mse;
}
//-----------------------------------------------------------------------------
void cpuKernel(const float* const a,float* c, const int m, const int n) { // entire matrix 
    for(int i = 0; i < n ; i++){
        float newTemp = a[i];
        if(i==0)
            newTemp += k_const * ( a[i+1] - a[i] );
        else if(i==n-1)
            newTemp += k_const * ( a[i-1] - a[i] );
        else
            newTemp += k_const * ( a[i+1] + a[i-1] - 2 * a[i] );
        c[i] = newTemp;
    }
 
}


//-----------------------------------------------------------------------------
void gpuKernels(const float* const a, float* c, const int m, const int n, double* gpu_kernel_time) {

	float* ad;
	float* cd;


    HANDLE_ERROR(cudaMalloc((void**)&ad, n * sizeof(float)));
    HANDLE_ERROR(cudaMalloc((void**)&cd, n * sizeof(float)));

    HANDLE_ERROR(cudaMemcpy(ad, a, n * sizeof(float), cudaMemcpyHostToDevice));
	HANDLE_ERROR(cudaMemcpy(cd, c, n * sizeof(float), cudaMemcpyHostToDevice));
	//HANDLE_ERROR(cudaBindTexture(NULL, texref, ad, n * sizeof(float)));
	//dim3 dimGrid = getDimGrid(m,n); //modify this function in bmm.cu
	//dim3 dimBlock = getDimBlock(m,n); //modify this function in bmm.cu

	GpuTimer timer;
    timer.Start();
	gpuKernel(ad,cd,n,m);
	//kernelFunc<<< (16),(1024) >>>(ad , cd, n, m); //modify this function in bmm.cu
	timer.Stop();
	*gpu_kernel_time = timer.Elapsed();
    
	HANDLE_ERROR(cudaMemcpy(c, cd, n * sizeof(float), cudaMemcpyDeviceToHost));
	//cudaUnbindTexture(texref);

    HANDLE_ERROR(cudaFree(ad));
    HANDLE_ERROR(cudaFree(cd));
}
