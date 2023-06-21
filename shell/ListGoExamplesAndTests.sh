#!/usr/bin/bash
totalExamples=0
totalTests=0

# Local root of the Go code examples (for Cygwin)
src=/cygdrive/d/src/aws-doc-sdk-examples/go/example_code

# Find all Go files and tests
for i in `find $src -type d`
do
    pushd $i > /dev/null 2>&1
    /usr/bin/ls *.go > go_masterList.txt 2> /dev/null 
    grep _test.go go_masterList.txt > test_masterList.txt

    numExamples=$(< go_masterList.txt wc -l)
    numTests=$(< test_masterList.txt wc -l)

    totalExamples=$((totalExamples + numExamples))
    totalTests=$((totalTests + numTests))

    echo "Found $numExamples Go examples in $i"
    echo "of which there are $numTests tests"
    echo
    
    rm go_masterList.txt test_masterList.txt > /dev/null 2>&1
    popd > /dev/null 2>&1
done

echo "Found $totalExamples total Go examples"
echo "of which there are $totalTests tests"
