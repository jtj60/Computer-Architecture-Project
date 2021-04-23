#include <omp.h>			
#include <stdio.h>
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
	int mark = 90;
	char letter = 'F';
	#pragma omp parallel 
	{
		gradeCheck(&mark,&letter);
	}
	
	printf("Number Grade: %d\t Letter Grade: %c\n",mark,letter);
	return 0;
}
