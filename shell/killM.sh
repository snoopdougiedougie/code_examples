#!/usr/bin/bash

# Deletes ^Ms from input file
unix2dos $1

# Create temporary file
#   tmp=$$

# cat $1 | sed s/'
# mv $tmp $1