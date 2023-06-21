#!/usr/bin/bash

# Rename any *.bak files as *

for i in `echo *.bak`
do
    # Compare each file
    orig=`basename -s .bak $i`

    rm $orig
    mv $i $orig
done
