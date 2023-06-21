#!/usr/bin/bash

echo To check how many embedded programlisting entries are in the XML files hit Enter
echo otherwise hit Ctrl-C to quit
echo " "

read line

tmpfile=$$

for i in `echo *.xml`
do
    grep \<programlisting $i | sed /txt/d > $tmpfile
    numhits=`wc -l $tmpfile`

    echo $i had $numhits
done

rm $tmpfile

