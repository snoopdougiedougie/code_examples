#!/usr/bin/bash

echo To check how many files are changed in my CDK branches hit Enter
echo otherwise hit Ctrl-C to quit
echo " "

read line

for i in `echo *.xml`
do
    output=`grep $i *.xml`

    if [ "$output" == "" ]
    then
        echo "You can delete $i"
    else
        # Show output
        echo $output
    fi
done

