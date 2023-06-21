#!/usr/bin/bash

# Looks for:
#     // snippet-keyword:[API function]
# in each .go file in each service folder
# and produces:
#     API

totalOps=0

# Local root of the Go code examples (for Cygwin)
src=/cygdrive/d/src/aws-doc-sdk-examples/go/example_code

# Find all Go files and tests
for i in `find $src -type d`
do
    pushd $i > /dev/null 2>&1
    # Lop off:
    #     // snippet-keyword:[
    # This shows:
    #    source-filename:function
    #    grep snippet-keyword *.go | grep function | sed s/'\/\/ snippet-keyword:\['// | sed s/' function\]'// > funcs.txt
    # so delete everything before the colon:
    grep snippet-keyword *.go | grep function | sed s/'\/\/ snippet-keyword:\['// | sed s/' function\]'// | sed s/'.*.go:'// > funcs.txt
    numOps=$(< funcs.txt wc -l)
    totalOps=$((totalOps + numOps))

    echo "Found $numOps operations in $i:"
    cat funcs.txt
    echo
    
    rm funcs.txt > /dev/null 2>&1
    popd > /dev/null 2>&1
done

echo "Found $totalOps total operations in the Go examples"
