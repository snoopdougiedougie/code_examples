#!/usr/bin/bash

# Changes all instances of example_code/* to just *
# in each file in each folder from here on down

# Find all files
for i in `find . -type f`
do
    sed -i 's/example_code\///g' $i
    unix2dos $i 2> /dev/nul
done
