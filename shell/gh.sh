#!/usr/bin/bash

# Delete and touch the files in the current directory and all sub-directories
set +C
find . -type f -exec echo '' > {} \;
set -C

echo Done
