#!/usr/bin/bash

# To search for a tab in FILE:
#     grep $'\t' FILE

masterList=./go_masterList.txt

if [ -e $masterList ]
then
  rm $masterList
fi

 fileType="*.go"

# Get the list of all $fileType files from here on down
find . -type f -name "${fileType}" -print > $masterList

# Change " " to "\ "
tmp=$$.txt
cat $masterList | sed s/' '/'\\ '/ > $tmp
mv $tmp $masterList

# Barf out contents of master list, one at a time
cat $masterList |
while read line
do
  expand --tabs=4 $line > $tmp

  # If the files differ, we replaced tabs
  found=`diff -q $line $tmp`

    # If not, delete tmp file
    if [ "$found" == "" ]
    then
        rm $tmp
    else
        echo "Expanded tabs in $line"
        mv $tmp $line
    fi
done
  
