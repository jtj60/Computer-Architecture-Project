#include <stdio.h>
#include <cuda.h>

#define BLOCKS 1
#define THREADS 1
#define SIZE	1000	//MAX array size
#define GLOBAL_W	50

__global__ void knapsack(int *val, int *wt,int *result) {
	int K[SIZE + 1][GLOBAL_W + 1];
	
	//FOR LOOP
	for(int i =0;i <= SIZE;i++) {
		for(int w = 0;w <= GLOBAL_W;w++){
			
			if(i == 0 || w == 0)
				K[i][w] = 0;
			else if(wt[i -1] <= w) {
				int a,b;
				a = val[i-1] + K[i-1][w - wt[i - 1]];
				b = K[i-1][w];
				
				K[i][w] = (a > b) ? a : b;
			}
			else
				K[i][w] = K[i -1][w];
		}
	}
	*result = K[SIZE][GLOBAL_W];
}

int main() {
	int val[SIZE];
	int wt[SIZE];
	int result = 0;
	
	int *dVal, *dWt,*dRes;
	
	//Initialize  Array
	for (int i = 0; i<SIZE; i++){
		val[i] = rand() % 100 +1;
		wt[i] = rand() % 100 +1;
	}
	
	//allocate GPU memory
	cudaMalloc(&dVal,(sizeof(val)/sizeof(val[0])) * sizeof(int));
	cudaMalloc(&dWt,(sizeof(wt)/sizeof(wt[0])) * sizeof(int));
	cudaMalloc(&dRes,sizeof(int));
	
	//copy values from cpu to gpu
	cudaMemcpy(dVal, &val, SIZE * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dWt, &wt, SIZE * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dRes, &result, sizeof(int), cudaMemcpyHostToDevice);
	
	
	//call kernel function
	knapsack<<<BLOCKS,THREADS>>>(dVal,dWt,dRes);
	
	//wait for gpu to finish
	cudaDeviceSynchronize();
	
	//copy result from gpu to cpu
	cudaMemcpy(&result,dRes, sizeof(int), cudaMemcpyDeviceToHost);
	
	printf("Result: %d\n", result);
	
	//free gpu memory
	cudaFree(dVal);
	cudaFree(dWt);
	cudaFree(dRes);
	return 0;
}
