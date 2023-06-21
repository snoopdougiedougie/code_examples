#!/usr/bin/bash

# We require an arg
if [ "$1" == "" ]
then
    echo No arg--goodbye    
else
    py /c/users/snoop/appdata/roaming/python/python310/site-packages/sgpt.py "$1"
fi

echo See https://github.com/TheR1D/shell_gpt for more info.
