#!/bin/bash
CPROGRAM=VectorAdd
CUDAPROGRAM=VectorAddCuda
PASSWORD=garrett1

#C program commands
for num in {1..10}
do
echo $PASSWORD | sudo -S perf stat --event cache-references,cache-misses,cycles,page-faults,instructions,cpu-clock ./$CPROGRAM
done
#for num in {1..10}
#do
#cuda program commands
#echo $PASSWORD | sudo -S nvprof --print-gpu-trace --print-api-trace ./$CUDAPROGRAM
#done 
