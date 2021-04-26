#! /bin/bash
CFILE=VectorAdd.c
CFILEEXEC=VectorAdd
CUDAFILE=VectorAddCuda.cu
CUDAFILEEXEC=VectorAddCuda

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
echo garrett1 | sudo -S nvprof --print-gpu-trace --print-api-trace ./$CUDAFILEEXEC
done 
