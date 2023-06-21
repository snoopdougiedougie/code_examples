#!/usr/bin/bash

# If we are not in the C: drive, we might not be able to create the list,
# so create it on the C: drive and delete it later

onC=`pwd | grep "\/cygdrive\/c"`

if [ "$onC" == "" ]
then
    root="/cygdrive/c"
else
    root="."
fi

# Create master list
masterList=${root}/all_masterList.txt

# Recreate the list if it does not exist
if ! [ -e $masterList ]
then
    echo "Creating master list ${masterList}"

    # Get the list of all directories from here on down
    find . -type d -print > $masterList

    # Change " " to "\ "
    tmp=$$.txt
    cat $masterList | sed s/' '/'\\ '/ > ${root}/$tmp
    mv ${root}/$tmp $masterList
fi

# Search the master list for input value
echo "Searching ${masterList} for $1"
grep -i "$1" $masterList

echo
echo "Delete $masterList to force re-search for directories the next time"
echo
