#!/usr/bin/bash

sed -i 's/example_code\///g' $1
unix2dos $1 2> /dev/nul
