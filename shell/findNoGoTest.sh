#!/usr/bin/bash

while getopts f:t: flag
do
    case "${flag}" in
	f) fileList=${OPTARG};;
	t) testList=${OPTARG};;
    esac
done

# Barf out contents of source list, one at a time
cat $fileList |
while read line
do
    testName=`basename $line .go`
    testName=${testName}_test.go

#    echo "Searching for $testName in $testList"
    
    found=`grep "$testName" "$testList"`

    if [ "$found" == "" ]
    then
        echo "$line does not have a corresponding unit test"
    fi
done
