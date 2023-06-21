#!/usr/bin/bash

for i in $(ls *.c 2> /dev/null)
do
    cat $i 2> /dev/null | grep $1 > /dev/null 2>&1
    STATUS=$?
    if [ $STATUS  -eq 0 ] ; then
        echo "Found"
        exit
    fi
done

echo "Not found"