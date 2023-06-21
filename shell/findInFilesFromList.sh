#!/usr/bin/bash

# Search all files for entries in $1
if [ "$1" == "" ]
then
    echo "You must supply the list of search item"
    exit
fi

# Barf out contents of search list
cat $1 |
while read line
do
    found=`grep -l "$line" *.*`

    if [ "$found" != "" ]
    then
        echo -n
        echo "Found $line in $found"
    fi
done
