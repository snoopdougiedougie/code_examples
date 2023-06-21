#!/usr/bin/bash

# Compare the files in the current directory against input directory

echo Comparing the files in this directory to $1

for i in `echo *.*`
do
        # Compare each file
        echo To diff $i press enter
        read line
        diff -w $i $1/$i
done
