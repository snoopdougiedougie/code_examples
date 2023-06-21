#!/usr/bin/bash

# Removes smart quotes from file.
# It takes one arg, the filename
# If we don't have an arg, bail with error message
if [ "$1" == "" ]
then
    echo "You must specify the file to clean up"
    exit
fi

tmpfile=$$.tmp

cat $i | sed "s/[”“]/'\"'/g" > $tmpfile

mv $tmpfile $i
