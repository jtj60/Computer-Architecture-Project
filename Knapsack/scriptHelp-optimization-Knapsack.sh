#! /bin/bash
CFILE=knapsack.c
CFILEEXEC=knapsack
CUDAFILE=knapsackCuda.cu
CUDAFILEEXEC=knapsackCuda

#Optimization Level C File
for num in {1..3}
do
echo "Optimization Level O$num"
gcc -o $CFILEEXEC -O$num $CFILE -fopenmp
echo garrett1 | sudo -S perf stat --event cache-references,cache-misses,cycles,page-faults,instructions,cpu-clock ./$CFILEEXEC
done

#Optimization Level Cuda File
for num in {1..3}
do
echo "Optimization Level O$num"
nvcc -Xptxas -o $CUDAFILEEXEC -O$num $CUDAFILE
echo garrett1 | sudo -S nvprof --events inst_issued,l1_cache_global_hit_rate,l2_l1_read_hit_rate,nc_cache_global_hit_rate,issued_ipc ./$CUDAFILEEXEC
done 
