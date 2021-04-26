#! /bin/bash
CFILE=10_matrix_multiplication.c
CFILEEXEC=10_matrix_multiplication
CUDAFILE=10_matrix_multiplicationCuda.cu
CUDAFILEEXEC=10_matrix_multiplicationCuda
PASSWORD=garrett1
#Optimization Level C File
for num in {1..3}
do
echo "Optimization Level O$num"
gcc -o $CFILEEXEC -O$num $CFILE -fopenmp
echo $PASSWORD | sudo -S perf stat --event cache-references,cache-misses,cycles,page-faults,instructions,cpu-clock ./$CFILEEXEC
done

#Optimization Level Cuda File
for num in {1..3}
do
echo "Optimization Level O$num"
nvcc -o $CUDAFILEEXEC -O$num $CUDAFILE
echo $PASSWORD | sudo -S nvprof --events inst_issued,l1_cache_global_hit_rate,l2_l1_read_hit_rate,nc_cache_global_hit_rate,issued_ipc ./$CUDAFILEEXEC
done 
