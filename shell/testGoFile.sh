#!/usr/bin/bash

TestGoFile () {
    if [ "$1" == "" ]
    then
       return 0
    fi

    pushd $1

    declare RESULT=(`go test`)  # (..) = array
    
    if [ "${RESULT[0]}" == "PASS" ]
    then
      echo 0
    else
      echo 1
    fi

    popd
}

for f in $@ ; do
    # Do any end with "_test.go"?
    path="$(dirname $f)"
    file="$(basename $f)"

    echo Testing go file $file in $path

    # If it's a go test file
    # test it
    if [ "$file" == "^[a-zA-Z]*_test.go$" ]
    then
	TestGoFile "$path"
    else
	echo 0
    fi
done
