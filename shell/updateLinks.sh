#!/usr/bin/bash
echo Press enter to update links to master to links to main
echo Otherwise press Ctrl-C to quit
read line

masterList=all_masterList.txt

# Create list of all files from here on down
if [ -e $masterList ]
then
    echo Deleting existing master list
    rm $masterList
fi

echo Creating master list $masterList

# Get the list of all $fileType files from here on down
find . -type f -name "*.*" -print > $masterList

# Change " " to "\ "
tmp=$$.txt
cat $masterList | sed s/' '/'\\ '/g > $tmp
mv $tmp $masterList

# Loop through list of files
# REPLACE:
FROM_BLOB=awsdocs/aws-doc-sdk-examples/blob/master
FROM_TREE=awsdocs/aws-doc-sdk-examples/tree/master
TO_BLOB=awsdocs/aws-doc-sdk-examples/blob/main
TO_TREE=awsdocs/aws-doc-sdk-examples/tree/main

echo
echo Replacing $FROM_BLOB with $TO_BLOB
echo and $FROM_TREE with $TO_TREE
echo

cat $masterList |
while read line
do
    # Use + as sed separator
    sed -i 's+'${FROM_BLOB}'+'${TO_BLOB}'+g' $line
    sed -i 's+'${FROM_TREE}'+'${TO_TREE}'+g' $line

    found=`git diff "$line" 2> /dev/null`

    if [ "$found" != "" ]    
        then
            echo ""
            echo "Updated $line"
        else
            echo -n "."
        fi
done

echo
echo Done
echo
