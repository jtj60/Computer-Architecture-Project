#include <stdio.h>
#include <cuda.h>

#define SIZE 10000
#define THREADS 1
#define CORES 1
#define TILE_SIZE 32
__global__ void add( int *a, int *b, int *c ) {
	int blockId = (gridDim.x * blockIdx.y) + blockIdx.x;
	int tid = 	(blockId * blockDim.x) + threadIdx.x; // handle date at index
	if(tid < SIZE)
		c[tid] = a[tid] + b[tid];
	__syncthreads();
}
int main( void ) {
	int a[SIZE], b[SIZE], c[SIZE];
	
	int *dA, *dB, *dC;
	
	//allocate memory to GPU
	cudaMalloc(	(void**)&dA, SIZE * sizeof(int));
	cudaMalloc(	(void**)&dB, SIZE * sizeof(int));
	cudaMalloc(	(void**)&dC, SIZE * sizeof(int));
	
	// fill the arrays 'a' and 'b' on the CPU
	for (int i=0; i<SIZE; i++) {
		a[i] = -i;
		b[i] = i * i;
	}
	
	//copy arrays a and b to GPU
	cudaMemcpy(dA,a, SIZE*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dB,b, SIZE*sizeof(int), cudaMemcpyHostToDevice);
	
	dim3 dimGrid(SIZE/TILE_SIZE,SIZE/TILE_SIZE, 1);
	dim3 dimBlock(TILE_SIZE, TILE_SIZE, 1);
	
	add<<<dimGrid,dimBlock>>>( dA, dB, dC );
	
	//wait for gpu to finish
	cudaDeviceSynchronize();
	
	//copy array c from GPU to CPU
	cudaMemcpy(c, dC, SIZE*sizeof(int), cudaMemcpyDeviceToHost);
	
	// display the results
	
	for (int i=0; i<SIZE; i++) {
		printf( "%d + %d = %d\n", a[i], b[i], c[i] );
	}
	
	//free memory from GPU
	cudaFree(dA);
	cudaFree(dB);
	cudaFree(dC);
	
	return 0;
}
