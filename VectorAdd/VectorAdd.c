#include <stdio.h>
#include <omp.h>

#define N 10
void add( int *a, int *b, int *c ) {
	#pragma omp parallel for
		for(int tid =0; tid < N; tid++)
			c[tid] = a[tid] + b[tid];
}
int main( void ) {
	int a[N], b[N], c[N];
	
	// fill the arrays 'a' and 'b' on the CPU
	for (int i=0; i<N; i++) {
		a[i] = -i;
		b[i] = i * i;
	}
	
	#pragma omp parallel 
	{
		add( a, b, c );
	}
	// display the results
	
	for (int i=0; i<N; i++) {
		printf( "%d + %d = %d\n", a[i], b[i], c[i] );
	}
	
	return 0;
}
