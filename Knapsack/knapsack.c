#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#define SIZE 1000
void knapsack(int *W, int *val, int *wt, int *n, int *res) {
	//base
	int K[*n + 1][*W + 1];
		for(int i =0;i <= (*n);i++) {
			for(int w = 0; w <= (*W); w++){
				
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
	
	*res = K[*n][*W];
}

int main() {
	
	int val[SIZE];
	int wt[SIZE];
	
	//Initialize  Array
	for (int i = 0; i<SIZE; i++){
		val[i] = rand() % 100 +1;
		wt[i] = rand() % 100 +1;
	}
	
	int W = 50;
	int result = 0;
	int n = sizeof(val)/sizeof(val[0]);
	
	#pragma omp parallel num_threads(1)
	{
		knapsack((int*)&W, (int*)&val, (int*)&wt, (int*)&n, (int *)&result);
	}
	
	printf("Result: %d\n", result);
	return 0;
}
