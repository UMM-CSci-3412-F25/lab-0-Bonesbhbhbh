#!/usr/bin/bash

tar zxf ./NthPrime.tgz # uncompress and extract directory
cd NthPrime || exit # enter directory or quit

gcc -o NthPrime nth_prime.c main.c # compile two c files into one named NthPrime

./NthPrime "$1" # run compiled code with command line input

# rm -rf NthPrime # housekeeping