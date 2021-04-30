							
#include <stdio.h>
#include <cuda.h>
#include <stdlib.h>

#define BLOCKS 1
#define THREADS 1
#define SIZE 10000
#define TILE_SIZE 32
__global__ void gradeCheck(int *numGrad, char *gradLetter) {
	int blockId = (gridDim.x * blockIdx.y) + blockIdx.x;
	int tid = (blockId * blockDim.x) + threadIdx.x;
	
	if(numGrad[tid] >= 90 && numGrad[tid] <= 100)
		gradLetter[tid] = 'A';
	
	else if(numGrad[tid] >= 80 && numGrad[tid] < 90)
		gradLetter[tid] = 'B';
	
	else if(numGrad[tid] >= 70 && numGrad[tid] < 80)
		gradLetter[tid] = 'C';
	
	else if(numGrad[tid] >= 60 && numGrad[tid] < 70)
		gradLetter[tid] = 'D';
	
	else if(numGrad[tid] >= 0 && numGrad[tid] < 60)
		gradLetter[tid] = 'F';
		
	//printf("ThreadId: %d: Number Grade: %d\t Letter Grade: %c\n",tid,numGrad[tid],gradLetter[tid]);
		__syncthreads();
		
}
//__global__ void printArray(int *numGrad, char *gradLetter)
int main() {
	int marks[SIZE];
	char letter[SIZE];
	
	int *dMarks;
	char *dLetter;
	
	int upper = 100;
	int lower = 50;
	
	//Initialize  Array
	for (int i = 0; i<SIZE; i++){
		marks[i] = (rand() % (upper - lower + 1)) + lower;
		letter[i] = 'F';
	}
	
	//allocate memory
	cudaMalloc(&dMarks,SIZE * sizeof(int));
	cudaMalloc(&dLetter,SIZE * sizeof(char));
	
	//copy data from cpu to gpu
	cudaMemcpy(dMarks,&marks,SIZE * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dLetter,&letter,SIZE * sizeof(char), cudaMemcpyHostToDevice);
	
	//Define grid and block dimensions
	dim3 dimGrid(SIZE/100,SIZE/100,1);
	dim3 dimBlock(TILE_SIZE, TILE_SIZE, 1);
	
	//execute kernel function
	gradeCheck<<<dimGrid,dimBlock>>>(dMarks,dLetter);
	
	//wait for gpu to finish
	cudaDeviceSynchronize();
	
	//copy data from gpu to cpu
	cudaMemcpy(&letter,dLetter, SIZE * sizeof(char), cudaMemcpyDeviceToHost);
	cudaMemcpy(&marks,dMarks, SIZE * sizeof(int), cudaMemcpyDeviceToHost);
	
	//print result
	for(int i =0; i<SIZE;i++)
		printf("%d: Number Grade: %d\t Letter Grade: %c\n",i,marks[i],letter[i]);
	
	//free gpu memory
	cudaFree(dMarks);
	cudaFree(dLetter);
	return 0;
}
