#!/usr/bin/bash

# Deletes all of the target directories and Cargo.lock files from here on down

masterList=./lock_masterList.txt

if [ -e $masterList ]
then
  rm $masterList
fi

fileType="Cargo.lock"

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
  rm $line
done
  
rm $masterList

# Now do the same for target directories

masterList=./lock_masterList.txt

if [ -e $masterList ]
then
  rm $masterList
fi

fileType="target"

# Get the list of all $fileType directories from here on down
find . -type d -name "${fileType}" -print > $masterList

# Change " " to "\ "
tmp=$$.txt
cat $masterList | sed s/' '/'\\ '/ > $tmp
mv $tmp $masterList

# Barf out contents of master list, one at a time
cat $masterList |
while read line
do
  rm -rf $line
done
  
rm $masterList

