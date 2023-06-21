#!/usr/bin/bash

# Replace $1 with $2 in all $3 files in current folder

# First make sure we have three args
if [ "$3" == "" ]
then
    echo "You must supply three args: the string to replace, the string to replace it with, and the extension of the files in which the strings are replaced"
    exit
fi

echo "To replace '$1' with '$2' in all $3 files in this directory"
echo "press enter"
echo "otherwise hit Ctrl-C to quit"
echo -n

read line

tmpfile=$$

for i in `echo *.$3`
do
#    echo "Searching $i"
    
    cat $i | sed "s/$1/$2/" > $tmpfile

    # Replace original file
    mv $tmpfile $i
done
