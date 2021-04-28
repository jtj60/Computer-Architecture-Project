#include <stdio.h>
#include <omp.h>

#define N 10
void add( int *a, int *b, int *c ) {
	int tid = omp_get_thread_num();
		if(tid < N)
			c[tid] = a[tid] + b[tid];
}
int main( void ) {
	int a[N], b[N], c[N];
	
	int numOfThreads = N;
	
	// fill the arrays 'a' and 'b' on the CPU
	for (int i=0; i<N; i++) {
		a[i] = -i;
		b[i] = i * i;
	}
	
	#pragma omp parallel num_threads(numOfThreads)
	{
		add( a, b, c );
	}
	// display the results
	
	for (int i=0; i<N; i++) {
		printf( "%d + %d = %d\n", a[i], b[i], c[i] );
	}
	
	return 0;
}
