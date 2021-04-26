// C program to multiply two square matrices.
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#define N 4

// This function multiplies mat1[][] and mat2[][],
// and stores the result in res[][]
void multiply(int mat1[][N], int mat2[][N], int res[][N])
{
	int i, j, k;
	for (i = 0; i < N; i++) {
		for (j = 0; j < N; j++) {
			res[i][j] = 0;
			for (k = 0; k < N; k++)
				res[i][j] += mat1[i][k] * mat2[k][j];
		}
	}
}

int main()
{
	int mat1[N][N] = { { 1, 1, 1, 1 },
					{ 2, 2, 2, 2 },
					{ 3, 3, 3, 3 },
					{ 4, 4, 4, 4 } };

	int mat2[N][N] = { { 1, 1, 1, 1 },
					{ 2, 2, 2, 2 },
					{ 3, 3, 3, 3 },
					{ 4, 4, 4, 4 } };

	int res[N][N]; // To store result
	int i, j;
	
	/*pointers
	int **dMat1=(int **)malloc(N*N*sizeof(int));
	int **dMat2=(int **)malloc(N*N*sizeof(int));
	int **dRes=(int **)malloc(N*N*sizeof(int));*/
	
	/*copy data to poitners
	memccpy(dMat1, mat1, N*N*sizeof(int));
	memccpy(dMat2, mat2, N*N*sizeof(int));
	memccpy(dRes, res, N*N*sizeof(int));*/
	#pragma omp parallel 
	{
		multiply(mat1,mat2,res);
	}
	//copy pointer data to result
	//memccpy(res, dRes, N*N*sizeof(int));
	
	//display result
	printf("Result matrix is \n");
	for (i = 0; i < N; i++) {
		for (j = 0; j < N; j++)
			printf("%d ", res[i][j]);
		printf("\n");
	}
	
	//free data
	/*free(dMat1);
	free(dMat2);
	free(dRes);*/
	return 0;
}
