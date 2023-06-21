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
if [ -e $masterList ]
then
    echo "Found master list $masterList"
else

    # Get the list of all $fileType files from here on down
    find . -type f -name "${fileType}" -print > $masterList

    # Change " " to "\ "
    tmp=$$.txt
    cat $masterList | sed s/' '/'\\ '/ > $tmp
    mv $tmp $masterList
fi

# Now see if any CS file has the requested operation
echo "Searching for $1 in $fileType files"
echo

# Barf out contents of master list, one at a time
cat $masterList |
while read line
do
    found=`grep "$1" "$line"`

    if [ "$found" != "" ]    
        then
            echo ""
            echo "$line: $found"
        else
            echo -n "."
        fi
done

echo
echo "Delete $masterList to force re-search for $fileType files the next time"
echo
