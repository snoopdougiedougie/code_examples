#!/usr/bin/bash

# If we don't have an arg, bail with error message
if [ "$1" == "" ]
then
    echo "You must tell me the file with list of RST files to search"
    exit
fi

# Barf out all abc in |abc| in all files in given arg
for i in `cat $1`
do
    cat $i | awk -F\| {'print $2'} | sed '/^$/d'
done
