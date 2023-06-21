#!/usr/local/bin/bash

# Delete any ^Ms out of the input file
sed -e 's///' < $1 > $$.txt
cp $$.txt $1
