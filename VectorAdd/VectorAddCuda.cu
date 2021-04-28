#include <stdio.h>
#include <cuda.h>

#define N 1000
#define THREADS 1
#define CORES 1
__global__ void add( int *a, int *b, int *c ) {
	int tid = threadIdx.x;	// handle date at index
	c[tid] = a[tid] + b[tid];
	__syncthreads();
}
int main( void ) {
	int a[N], b[N], c[N];
	
	int *dA, *dB, *dC;
	
	//allocate memory to GPU
	cudaMalloc(	(void**)&dA, N * sizeof(int));
	cudaMalloc(	(void**)&dB, N * sizeof(int));
	cudaMalloc(	(void**)&dC, N * sizeof(int));
	
	// fill the arrays 'a' and 'b' on the CPU
	for (int i=0; i<N; i++) {
		a[i] = -i;
		b[i] = i * i;
	}
	//copy arrays a and b to GPU
	cudaMemcpy(dA,a, N*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dB,b, N*sizeof(int), cudaMemcpyHostToDevice);
	
	add<<<CORES,N>>>( dA, dB, dC );
	
	//wait for gpu to finish
	cudaDeviceSynchronize();
	
	//copy array c from GPU to CPU
	cudaMemcpy(c, dC, N*sizeof(int), cudaMemcpyDeviceToHost);
	
	// display the results
	
	for (int i=0; i<N; i++) {
		printf( "%d + %d = %d\n", a[i], b[i], c[i] );
	}
	
	//free memory from GPU
	cudaFree(dA);
	cudaFree(dB);
	cudaFree(dC);
	
	return 0;
}
