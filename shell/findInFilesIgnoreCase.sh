#!/usr/bin/bash

# If we are not in the C: drive, we might not be able to create the list,
# so create it on the C: drive and delete it later

onC=`pwd | grep "\/cygdrive\/c"`

#if [ "$onC" == "" ]
#then
#    root="/cygdrive/c"
#else
    root="."
#fi

# If we don't have two args, search all files
if [ "$2" == "" ]
then
    fileType="*.*"
    masterList=${root}/all_masterList.txt
else
    fileType="*."${2}

    # Create the master list
    masterList=${root}/${2}_masterList.txt
fi

# Recreate the list if it does not exist
if [ -e $masterList ]
then
    echo "Found master list $masterList"
else
    echo "Creating master list $masterList"

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
    found=`grep -i "$1" "$line"`

    if [ "$found" != "" ]    
        then
            echo ""
            echo "$line: $found"
        else
            echo -n "."
        fi
done

if [ "$root" != "." ]
then
    rm $masterList
else
    echo
    echo "Delete $masterList to force re-search for $fileType files the next time"
    echo
fi
