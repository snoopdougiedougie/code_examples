#!/usr/local/bin/bash

if [ "$1" == "" ]
then
    echo "You must supply the extension of the files to make writable"
    exit 0
fi

# Build list of files to filter
fileType="*.$1"

echo "Making sure $1 files are writeable"

# Create the master list
masterList=./masterList.txt

# If master list exists, delete it
if [ -e $masterList ]
then
    rm $masterList
fi

# Get the list of all $fileType files from here on down
find . -name "${fileType}" -print > $masterList

# Change " " to "\ "
tmp=$$.txt
cat $masterList | sed s/' '/'\\ '/ > $tmp
mv $tmp $masterList

# Go through each file in the master list
cat $masterList |
while read file
do
    # Make sure the file is not read-only
    if [ ! -w "$file" ]
    then
        echo "Making $file writable"
        chmod +w $file
    fi  
done
