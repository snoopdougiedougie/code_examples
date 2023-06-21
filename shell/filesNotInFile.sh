#!/usr/bin/bash

# Determine if the filenames in arg 0 are in the current folder

# We must have at least on arg, the file to grep
if [ "$1" == "" ]
then
    echo You must have the file to grep
    echo and the optional file extension of the filenames to grep for
    exit
fi

# If we have only one arg, search all files
if [ "$2" == "" ]
then
    fileType="*.*"
else
    fileType="*."${2}
fi

masterList=list.$$

if [ -e $masterList ]
then
    rm $masterList
fi

#echo "Searching for ${fileType} files in ${1}"

# Create the list
/bin/ls -1 ${fileType} > $masterList

# Barf out contents of master list, one at a time
cat $masterList |
while read line
do
    # Don't search the file itself
    if [ "$line" != "$1" ]
    then
        found=`grep "$line" "$1"`

        if [ "$found" == "" ]    
        then
            echo "$line"
        fi
    fi
done

rm $masterList
