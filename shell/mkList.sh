#!/usr/bin/bash

# If we don't have an arg, search all files
if [ "$1" == "" ]
then
    fileType="*.*"
    echo Creating master list for ALL files
    masterList=./all_masterList.txt
else
    fileType="*."${1}
    echo Creating master list for ${fileType} files
    masterList=./${1}_masterList.txt
fi

# Recreate the list if it does not exist
if [ -e $masterList ]
then
    echo "Found master list $masterList"
else
    # Get the list of all $fileType files from here on down
    find . -type f -name "${fileType}" -print > $masterList

    # Change " " to "\ "
    tmp=$$.txt
    cat $masterList | sed s/' '/'\\ '/g > $tmp
    mv $tmp $masterList
fi

echo
echo "Delete $masterList to force re-search for $fileType files the next time"
echo
