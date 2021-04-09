							
#include <stdio.h>
#include <cuda.h>

#define BLOCKS 1
#define THREADS 1
__global__ void gradeCheck(int *numGrad, char *gradLetter) {
	
	if(*numGrad >= 90 && *numGrad <= 100)
		*gradLetter = 'A';
		
	else if(*numGrad >= 80 && *numGrad < 90)
		*gradLetter = 'B';
		
	else if(*numGrad >= 70 && *numGrad < 80)
		*gradLetter = 'C';
		
	else if(*numGrad >= 60 && *numGrad < 70)
		*gradLetter = 'D';
		
	else if(*numGrad >= 0 && *numGrad < 60)
		*gradLetter = 'F';
		
}
int main() {
	int mark = 90;
	char letter = 'F';
	
	int *dMark;
	char *dLetter;
	
	//allocate memory
	cudaMalloc(&dMark,sizeof(int));
	cudaMalloc(&dLetter,sizeof(char));
	
	//copy data from cpu to gpu
	cudaMemcpy(dMark,&mark,sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dLetter,&letter,sizeof(char), cudaMemcpyHostToDevice);
	
	//execute kernel function
	gradeCheck<<<BLOCKS,THREADS>>>(dMark,dLetter);
	
	//wait for gpu to finish
	cudaDeviceSynchronize();
	
	//copy data from gpu to cpu
	cudaMemcpy(&letter,dLetter, sizeof(char), cudaMemcpyDeviceToHost);
	cudaMemcpy(&mark,dMark, sizeof(int), cudaMemcpyDeviceToHost);
	
	//print result
	printf("Number Grade: %d\t Letter Grade: %c\n",mark,letter);
	
	//free gpu memory
	cudaFree(dMark);
	cudaFree(dLetter);
	return 0;
}
