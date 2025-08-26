#!/usr/bin/bash

int=$1

tar zxf ./NthPrime.tgz # uncompress and extract directory
cd NthPrime # enter directory

gcc -o NthPrime nth_prime.c main.c # compile two c files into one named NthPrime

./NthPrime $1 # run compiled code

# rm -rf NthPrime # housekeeping