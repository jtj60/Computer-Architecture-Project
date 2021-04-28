							
#include <stdio.h>
#include <cuda.h>
#include <stdlib.h>

#define BLOCKS 1
#define THREADS 1
#define SIZE 1000
__global__ void gradeCheck(int *numGrad, char *gradLetter) {
	int tid = threadIdx.x;
	
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
		
		__syncthreads();
		
}
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
	
	//execute kernel function
	gradeCheck<<<BLOCKS,SIZE>>>(dMarks,dLetter);
	
	//wait for gpu to finish
	cudaDeviceSynchronize();
	
	//copy data from gpu to cpu
	cudaMemcpy(&letter,dLetter, SIZE * sizeof(char), cudaMemcpyDeviceToHost);
	cudaMemcpy(&marks,dMarks, SIZE * sizeof(int), cudaMemcpyDeviceToHost);
	
	//print result
	for(int i =0; i<SIZE;i++)
		printf("Number Grade: %d\t Letter Grade: %c\n",marks[i],letter[i]);
	
	//free gpu memory
	cudaFree(dMarks);
	cudaFree(dLetter);
	return 0;
}
