#!/usr/bin/bash

# If we don't have two args, search all files
if [ "$2" == "" ]
then
    fileType="*.*"
    masterList=./all_masterList.txt
else
    fileType="*."${2}

    # Create the master list
    masterList=./${2}_masterList.txt
fi

# Recreate the list if it does not exist
if ! [ -e $masterList ]
then
    # Get the list of all $fileType files from here on down
    find . -type f -name "${fileType}" -print > $masterList

    # Change " " to "\ "
    tmp=$$.txt
    cat $masterList | sed s/' '/'\\ '/ > $tmp
    mv $tmp $masterList
fi

# Barf name of file we are looking for
echo "Looking for $1"

# Barf out contents of master list, one at a time
cat $masterList |
while read line
do
    grep -l "$1" "$line"
done
