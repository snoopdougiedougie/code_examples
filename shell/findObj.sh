#!/usr/local/bin/bash

fileType=$2

echo "Searching for $1. and new $1 in $fileType files"
echo

# Create the master list
masterList=./${fileType}_masterList.txt

# Recreate the list if it does not exist
if [ -e $masterList ]
then
    echo "Found master list"
    echo
else
    # Get the list of all $fileType files from here on down
    find . -type f -name "*.${fileType}" -print > $masterList

    # Change " " to "\ "
    tmp=$$.txt
    cat $masterList | sed s/' '/'\\ '/ > $tmp
    mv $tmp $masterList
fi

space=" "

# Barf out contents of master list, one at a time
cat $masterList |
while read fileName
do
#    echo "Searching ${fileName}"

    foundDot=`grep "$1\."   "$fileName"`

#    echo "foundDot = ${foundDot}"

    foundNew=`grep "new $1" "$fileName"`

#    echo "foundNew = ${foundNew}"

    found=${foundDot}${space}${foundNew}

#    echo "found = ${found}"

    if [ "$found" != " " ]
        then
            echo ""
            echo ${fileName}:

            # Barf out found contents
            echo $found |
            while read contents
            do
                echo "    $contents"
                echo ""
            done

            echo ""
        else
            echo -n "."
        fi
done

echo
echo "Delete $masterList to force re-search for $fileType files the next time"
echo

