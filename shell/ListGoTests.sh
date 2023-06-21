#!/usr/bin/bash

# Local root of the Go code examples (for Cygwin)
src=/cygdrive/d/src/aws-doc-sdk-examples/go/example_code

pushd $src

# Find all Go files and tests
for i in `find $src -type d`
do
    echo "Navigating to $i"
    pushd $i
    mkList.sh go
    numExamples=`wc -l go_masterList.txt`
    numTests=`grep _test.go go_masterList.txt | wc -l`

    echo "Found $numExamples Go examples in $i"
    echo "of which there are $numTests tests"
    
    rm go_masterList.txt
    popd
done

popd
