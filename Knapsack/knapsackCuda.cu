#include <stdio.h>
#include <cuda.h>

#define BLOCKS 64
#define THREADS 1

#define N	3
#define GLOBAL_W	50

__global__ void knapsack(int *val, int *wt,int *result) {
	int K[N + 1][GLOBAL_W + 1];
	
	/*GPU parallel
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	int w = blockIdx.y * blockDim.y + threadIdx.y;
	
	if(i <= N && w <= GLOBAL_W) {			
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
	__syncthreads();*/
	//FOR LOOP
	for(int i =0;i <= N;i++) {
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
	*result = K[N][GLOBAL_W];
}

int main() {
	int val[N] = {60,100,120};
	int wt[N] = {10,20,30};
	int result = 0;
	
	//int W = GLOBAL_W;
	//int n = N;
	
	int *dVal, *dWt,*dRes;
	//int *dW,*dN;
	
	//allocate GPU memory
	cudaMalloc(&dVal,sizeof(val) * sizeof(int));
	cudaMalloc(&dWt,sizeof(wt) * sizeof(int));
	cudaMalloc(&dRes,sizeof(int));
	
	//cudaMalloc(&dW,sizeof(int));
	//cudaMalloc(&dN,sizeof(int));
	
	//copy values from cpu to gpu
	cudaMemcpy(dVal, &val, 3 * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dWt, &wt, 3 * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dRes, &result, sizeof(int), cudaMemcpyHostToDevice);
	
	//cudaMemcpy(dW, &W, sizeof(int), cudaMemcpyHostToDevice);
	//cudaMemcpy(dN, &n, sizeof(int), cudaMemcpyHostToDevice);
	
	//call kernel function
	knapsack<<<CORES,THREADS>>>(dVal,dWt,dRes);
	
	//wait for gpu to finish
	cudaDeviceSynchronize();
	
	//copy result from gpu to cpu
	cudaMemcpy(&result,dRes, sizeof(int), cudaMemcpyDeviceToHost);
	
	printf("Result: %d\n", result);
	
	//free gpu memory
	cudaFree(dVal);
	cudaFree(dWt);
	cudaFree(dRes);
	//cudaFree(dW);
	//cudaFree(dN);
	return 0;
}
