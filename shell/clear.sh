#!/usr/bin/bash

# Delete and touch the file provided on the input line

rm -f "$1"
touch "$1"

echo "$1"
