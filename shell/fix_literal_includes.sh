#!/usr/bin/bash

# Tweaks ALL files so any line like:
#     .. literalinclude:: ../build_dependencies/1/ruby/...
# Becomes:
#     .. literalinclude:: ./...

echo Examining the RST files in this directory

for i in `echo *.rst`
do
    # Create tmp file
    tmp=$$.tmp
    bak=`basename $i .rst`.bak

    # run sed
    cat $i | sed s/'.. literalinclude:: ..\/build_dependencies\/1\/ruby'\/'.. literalinclude:: .'\/ > $tmp

    # Did we change anything?
    found=`diff -qw $i $tmp`

    # If not, delete tmp file
    if [ "$found" == "" ]
    then
        echo "No changes in $i"
        rm $tmp
    else
        cp $i $bak
        cp $tmp $i
    fi
done

echo "Delete bak file copies of originals"
