//Matrix multiplication
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#define TILESIZE 2


//Matrix multiplication
void MatrixMul(float *da, float *db, float *dc, int size)
{
	for (int col = 0; col<size;col++) {
		for(int row = 0; row<size; row++) {
			for (int k = 0; k< size; k++){
				*dc[row*size + col] += *da[row * size + k] *  (*db[k * size + col]);
			}
		}
	}
}

// main routine
int main()
{
	const int size = 4;
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
	
	MatrixMul(ha,hb,hresult,TILESIZE);
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
