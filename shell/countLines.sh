#!/usr/bin/bash

# If we don't have one arg, count the lines in all files
if [ "$1" == "" ]
then
    fileType="*.*"
    masterList=./all_masterList.txt
else
    fileType="*."${1}

    # Create the master list
    masterList=./${1}_masterList.txt
fi

# Recreate the list if it does not exist
if ! [ -e $masterList ]
then
    # Get the list of all $fileType files from here on down
    find . -name "${fileType}" -print > $masterList

    # Change " " to "\ "
    tmp=$$.txt
    cat $masterList | sed s/' '/'\\ '/ > $tmp
    mv $tmp $masterList
fi

# Barf out contents of master list, one at a time
cat $masterList |
while read line
do
    wc -l "$line"
done
