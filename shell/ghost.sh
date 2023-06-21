#!/usr/bin/bash

# Delete and touch the files in the current directory and all sub-directories

echo Ghosting

# Create master list of all files from here on down
mkList.sh > /dev/null 2>&1

# Iterate through the list, clearing and touching the files within
cat all_masterList.txt |
while read line
do
    if [ "$line" != "./all_masterList.txt" ]
    then
        clear.sh "$line"
    fi
done

rm -f all_masterList.txt

echo Done
