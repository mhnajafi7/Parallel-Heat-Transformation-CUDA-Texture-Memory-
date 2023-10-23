//Do NOT MODIFY THIS FILE

#ifndef HTT_H
#define HTT_H
#define k_const 0.1f
texture<float,cudaTextureType1D,cudaReadModeElementType> texref;
__global__ void kernelFunc(const float* oldtemperature,float* newtemperature, const unsigned int N, const unsigned int M);

#endif
//Do NOT MODIFY THIS FILE

