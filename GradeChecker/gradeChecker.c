#include <omp.h>			
#include <stdio.h>
#include <stdlib.h>
#define SIZE 1000
void gradeCheck(int *numGrad, char *gradLetter) {
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
	int marks[SIZE];
	char letter[SIZE];
	
	int upper = 100;
	int lower = 50;
	
	//Initialize  Array
	for (int i = 0; i<SIZE; i++){
		marks[i] = (rand() % (upper - lower + 1)) + lower;
		letter[i] = 'F';
	}
	
	int numOfThreads = SIZE;
	
	#pragma omp parallel num_threads(numOfThreads)
	{
		int tid = omp_get_thread_num();
		if(tid <SIZE)
			gradeCheck(&marks[tid],&letter[tid]);
	}
	for(int w =0; w<SIZE; w++)
		printf("Number Grade: %d\t Letter Grade: %c\n",marks[w],letter[w]);
	return 0;
}
