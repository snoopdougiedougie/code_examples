#!/usr/bin/bash

# We must have two args
if [ "$2" == "" ]
then
    echo You must have two folders to diff
    exit
fi

# Create tmp file to hold file list
list=$$

# Get the files in the first folder

/bin/ls -1 $1 > $list

cat $list |
while read line
do
    if [ -e "${2}/$line" ]
    then
        if  [ -f "${2}/$line" ]
        then
            diff "$1/$line" "$2/$line"
        fi
    else
        echo "$2/$line" does not exist
    fi
done

rm $list
