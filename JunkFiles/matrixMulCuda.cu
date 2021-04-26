//C program to multiply two square matrices.
#include <stdio.h>
#include <cuda.h>
#define N 4
#define BLOCKS 1
#define THREADS 1
// This function multiplies mat1[][] and mat2[][],
// and stores the result in res[][]
__global__ void multiply(int **mat1, int **mat2, int **res){
	/*int i = blockIdx.x * blockIdx.x + threadIdx.x;
	int j = blockIdx.y * blockIdx.y + threadIdx.y;
	int k = blockIdx.z * blockIdx.z + threadIdx.z;
	
	if(i < N) {
		if(j < N) {
			res[i][j] = 0;
			if(k < N)
				res[i][j] += mat1[i][k] * mat2[k][j];
		}
	}*/
	
	for(int i = 0;i < N;i++) {
		for(int j =0;j < N;j++) {
			res[i][j] = 0;
			for(int k =0;k < N;k++)
				res[i][j] += (mat1[i][k]) * (mat2[k][j]);
		}
	}
}
int main() {
	int **dMat1, **dMat2, **dRes;
	
	//allocate GPU memory
	cudaMalloc(&dMat1, N * N * sizeof(int));
	cudaMalloc(&dMat2, N * N * sizeof(int));
	cudaMalloc(&dRes, N * N * sizeof(int));
	
	//CPU varibles
	int mat1[N][N] = { { 1, 1, 1, 1 },
					{ 2, 2, 2, 2 },
					{ 3, 3, 3, 3 },
					{ 4, 4, 4, 4 } };

	int mat2[N][N] = { { 1, 1, 1, 1 },
					{ 2, 2, 2, 2 },
					{ 3, 3, 3, 3 },
					{ 4, 4, 4, 4 } };
	int res[N][N]; // To store result
	
	
	//copy data from cpu to gpu
	cudaMemcpy(&dMat1,&mat1, N * N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(&dMat2,&mat2, N * N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(&dRes,&res, N * N * sizeof(int), cudaMemcpyHostToDevice);
	
	multiply<<<BLOCKS,THREADS>>>(dMat1,dMat2,dRes);
	
	//wait for gpu to finish
	cudaDeviceSynchronize();
	//copy result data from GPU to CPU
	//cudaMemcpy(&mat1, &dMat1, N * N * sizeof(int), cudaMemcpyDeviceToHost);
	//cudaMemcpy(&mat2, &dMat2, N * N * sizeof(int), cudaMemcpyDeviceToHost);
	cudaMemcpy(&res, &dRes, N * N * sizeof(int), cudaMemcpyDeviceToHost);
	
	printf("Result matrix is \n");
	for (int i = 0; i < N; i++) {
		for (int j = 0; j < N; j++)
			printf("%d ", res[i][j]);
		printf("\n");
	}
	
	//free gpu memory
	cudaFree(dMat1);
	cudaFree(dMat2);
	cudaFree(dRes);
	
	return 0;
}
