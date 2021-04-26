#include <stdio.h>
#include <cuda.h>

#define BLOCKS 1
#define THREADS 1

#define N	3
#define GLOBAL_W	50

__global__ void knapsack(int *W, int *val, int *wt, int *n, int *result) {
	int K[N + 1][GLOBAL_W + 1];
	
	/*GPU parallel
	unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
	unsigned int w = blockIdx.y * blockDim.y + threadIdx.y;
	
	while(i <= (*n)) {
		while(w <= (*W)){
			
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
			w++;
		}
		i++;
	}
	__syncthreads();*/
	//FOR LOOP
	for(int i =0;i <= (*n);i++) {
		for(int w = 0;w <= (*W);w++){
			
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
	*result = K[*n][*W];
}

int main() {
	int val[N] = {60,100,120};
	int wt[N] = {10,20,30};
	int W = GLOBAL_W;
	int result = 0;
	int n = N;
	
	int *dVal, *dWt, *dW, *dRes, *dN;
	
	//allocate GPU memory
	cudaMalloc(&dVal,sizeof(val) * sizeof(int));
	cudaMalloc(&dWt,sizeof(wt) * sizeof(int));
	cudaMalloc(&dW,sizeof(int));
	cudaMalloc(&dRes,sizeof(int));
	cudaMalloc(&dN,sizeof(int));
	
	//copy values from cpu to gpu
	cudaMemcpy(dVal, &val, 3 * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dWt, &wt, 3 * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dW, &W, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dRes, &result, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dW, &W, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dN, &n, sizeof(int), cudaMemcpyHostToDevice);
	
	//call kernel function
	knapsack<<<BLOCKS,THREADS>>>(dW,dVal,dWt,dN,dRes);
	
	//wait for gpu to finish
	cudaDeviceSynchronize();
	
	//copy result from gpu to cpu
	cudaMemcpy(&result,dRes, sizeof(int), cudaMemcpyDeviceToHost);
	
	printf("Result: %d\n", result);
	
	//free gpu memory
	cudaFree(dW);
	cudaFree(dVal);
	cudaFree(dWt);
	cudaFree(dN);
	cudaFree(dRes);
	return 0;
}
