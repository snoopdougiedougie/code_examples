#!/usr/bin/bash

# Deletes empty lines from input file

# Create temporary file
tmp=$$

cat $1 | sed -e "s/^[ \t]*//" | sed /^$/d > $tmp
mv $tmp $1
