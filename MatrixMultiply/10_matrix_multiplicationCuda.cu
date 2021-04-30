//Matrix multiplication using shared and non shared kernal
#include "stdio.h"
#include<iostream>
#include <cuda.h>
#include <cuda_runtime.h>
#include <math.h>
#define TILE_SIZE 25
#define SIZE 100
//Matrix multiplication using non shared kernel
__global__ void gpu_Matrix_Mul_nonshared(float *d_a, float *d_b, float *d_c)
{
	int row, col;
	col = TILE_SIZE * blockIdx.x + threadIdx.x;
	row = TILE_SIZE * blockIdx.y + threadIdx.y;
	
	for (int k = 0; k< SIZE; k++)
	{
		d_c[row*SIZE + col] += d_a[row * SIZE + k] * d_b[k * SIZE + col];
	}
}

/* Matrix multiplication using shared kernel
__global__ void gpu_Matrix_Mul_shared(float *d_a, float *d_b, float *d_c, const int size)
{
	int row, col;
	//Defining Shared Memory
	__shared__ float shared_a[TILE_SIZE][TILE_SIZE];
	__shared__ float shared_b[TILE_SIZE][TILE_SIZE];
	col = TILE_SIZE * blockIdx.x + threadIdx.x;
	row = TILE_SIZE * blockIdx.y + threadIdx.y;

	for (int i = 0; i< size / TILE_SIZE; i++) 
	{
		shared_a[threadIdx.y][threadIdx.x] = d_a[row* size + (i*TILE_SIZE + threadIdx.x)];
		shared_b[threadIdx.y][threadIdx.x] = d_b[(i*TILE_SIZE + threadIdx.y) * size + col];
		__syncthreads(); 
		for (int j = 0; j<TILE_SIZE; j++)
			d_c[row*size + col] += shared_a[threadIdx.y][j] * shared_b[j][threadIdx.x];
		__syncthreads(); 

	}
}
*/
// main routine
int main()
{
	//Define Host Array
	float h_a[SIZE][SIZE], h_b[SIZE][SIZE],h_result[SIZE][SIZE];
	//Defining device Array
	float *d_a, *d_b, *d_result; 
	//Initialize host Array
	for (int i = 0; i<SIZE; i++)
	{
		for (int j = 0; j<SIZE; j++)
		{
			h_a[i][j] = i;
			h_b[i][j] = j;
		}
	}

	cudaMalloc((void **)&d_a, SIZE*SIZE*sizeof(int));
	cudaMalloc((void **)&d_b, SIZE*SIZE * sizeof(int));
	cudaMalloc((void **)&d_result, SIZE*SIZE* sizeof(int));


	//copy host array to device array

	cudaMemcpy(d_a, h_a, SIZE*SIZE* sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, h_b, SIZE*SIZE* sizeof(int), cudaMemcpyHostToDevice);
	
	//Define grid and block dimensions
	dim3 dimGrid(SIZE / TILE_SIZE, SIZE / TILE_SIZE, 1);
	dim3 dimBlock(TILE_SIZE, TILE_SIZE, 1);
	//gpu_Matrix_Mul_nonshared << <dimGrid, dimBlock >> > (d_a, d_b, d_result, size);

	gpu_Matrix_Mul_nonshared << <dimGrid, dimBlock >> > (d_a, d_b, d_result);

	cudaMemcpy(h_result, d_result, SIZE*SIZE * sizeof(int),	cudaMemcpyDeviceToHost);
	printf("The result of Matrix multiplication is: \n");
	
	for (int i = 0; i< SIZE; i++)
	{
		for (int j = 0; j < SIZE; j++)
		{
			printf("%f   ", h_result[i][j]);
		}
		printf("\n");
	}
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_result);
	return 0;
}
