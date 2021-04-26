#!/bin/bash
CPROGRAM=10_matrix_multiplication
CUDAPROGRAM=10_matrix_multiplicationCuda
PASSWORD=garrett1

#C program commands
for num in {1..10}
do
echo $PASSWORD | sudo -S perf stat --event cache-references,cache-misses,cycles,page-faults,instructions,cpu-clock ./$CPROGRAM
done
for num in {1..10}
do
#cuda program commands
echo $PASSWORD | sudo -S nvprof --events inst_issued,l1_cache_global_hit_rate,l2_l1_read_hit_rate,nc_cache_global_hit_rate,issued_ipc ./$CUDAPROGRAM
done 
