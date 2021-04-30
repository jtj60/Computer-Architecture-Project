//Matrix multiplication
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>
#define SIZE 100

//Matrix multiplication
void MatrixMul(float mat1[SIZE][SIZE], float mat2[SIZE][SIZE], float res[SIZE][SIZE])
{
	int i, j, k;
	#pragma omp parallel for
		for (i = 0; i < SIZE; i++) {
			#pragma omp parallel for
			for (j = 0; j < SIZE; j++) {
				res[i][j] = 0;
				#pragma omp parallel for
				for (k = 0; k < SIZE; k++)
					res[i][j] += mat1[i][k] * mat2[k][j];
			}
		}
}

// main routine
int main()
{
	const int size = SIZE;
	//Define Array
	float ha[size][size], hb[size][size], hresult[size][size];
	//Initialize  Array
	for (int i = 0; i<size; i++)
	{
		for (int j = 0; j<size; j++)
		{
			ha[i][j] = i;
			hb[i][j] = j;
		}
	}
	#pragma omp parallel
	{
		MatrixMul(ha,hb,hresult);
	}
	printf("The result of Matrix multiplication is: \n");
	
	for (int i = 0; i< size; i++)
	{
		for (int j = 0; j < size; j++)
		{
			printf("%f   ", hresult[i][j]);
		}
		printf("\n");
	}
	
	return 0;
}
