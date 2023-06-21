#!/usr/bin/bash
# We have one arg, the file extension
fileType="*."${1}

# Get list of  files and diff them with orig files
/bin/ls $fileType |
    while read line
    do
        orig=`basename -s .${1} $line`.orig

#        echo "Comparing $line to $orig"

        # Ignore white space
        diff -w $line $orig
    done
