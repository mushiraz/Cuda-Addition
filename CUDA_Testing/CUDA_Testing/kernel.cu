
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

__global__ void vectorAdd(int* a, int* b, int* c) {
	//Creates a list of threads 
	int i = threadIdx.x;
	c[i] = a[i] + b[i];
	return;
}

int main() {
	int a[] = { 1,2,3 };
	int b[] = { 4,5,6 };
	int c[sizeof(a) / sizeof(int)] = { 0 };

	

	// Creating pointers into the GPU
	int* cudaA = 0;
	int* cudaB = 0;
	int* cudaC = 0;

	//Allocate Memory in the GPU
	cudaMalloc(&cudaA, sizeof(a));
	cudaMalloc(&cudaB, sizeof(b));
	cudaMalloc(&cudaC, sizeof(c));
	
	//copy the vectors into the gpu
	cudaMemcpy(cudaA, a, sizeof(a), cudaMemcpyHostToDevice);
	cudaMemcpy(cudaB, b, sizeof(b), cudaMemcpyHostToDevice);
	
	//vectorAdd<<<GRID_SIZE, BLOCK_SIZE
	// grid_size= # of threads to be generated, in this case we dont want the process to create too many threads and cause issues
	//BLOCK_SIZE= # of vectors which in this case is 3 

	vectorAdd <<<1, sizeof(a) / sizeof(int) >>> (cudaA, cudaB, cudaC);

	cudaMemcpy(c, cudaC, sizeof(c), cudaMemcpyDeviceToHost);

	/* Created a for loop to be able to add the two vectors and display the result in C
	
	for (int i = 0; i < sizeof(c) / sizeof(int); i++) {
		c[i] = a[i] + b[i];
	}*/
	return;

}