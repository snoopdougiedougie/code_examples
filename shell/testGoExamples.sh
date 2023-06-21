#!/usr/bin/bash
start=`date +%s`

srcDir=/cygdrive/d/src/aws-doc-sdk-examples/go/example_code
destDir=/cygdrive/d/tmp/go_tests

# Make sure both directories exist
if [ -e $srcDir ]
then
    echo "Found source directory"
else
    echo "Could not find $srcDir"
    exit
fi

# Create destination directory if it doesn't exist
if [ ! -d "$destDir" ]; then
    echo Creating $destDir
    mkdir $destDir
fi

# Builds each Go example in $srcDir
# (D:\src\aws-doc-sdk-examples\go\example_code)

# Prep destination directory
pushd $destDir > /dev/nul 2>&1
rm *
touch output.txt
popd > /dev/nul 2>&1

# Navigate to src directory
pushd $srcDir > /dev/nul 2>&1

masterList="go_masterList.txt"

# echo Creating $masterList in $PWD

# Delete any old master list
rm $masterList > /dev/nul 2>&1
touch $masterList

# Create the list of go files
find . -type f -name *.go -print >> $masterList
numFiles=`wc -l $masterList`

for i in `cat $masterList`
do
    echo -n "."
    cp $i $destDir > /dev/nul 2>&1
    pushd $destDir > /dev/nul 2>&1
    f=`basename $i`
    e=`basename $f .go`.exe
    echo Building $i >> output.txt 2>&1
    go build $f      >> output.txt 2>&1
    rm $f $e         > /dev/nul 2>&1
    popd             > /dev/nul 2>&1
done

echo ""

popd > /dev/nul 2>&1
# Delete master list
rm $masterList > /dev/nul 2>&1

end=`date +%s`
runtime=$((end-start))

echo That took $runtime seconds to run

let minutes="$runtime / 60"
let remainder="$minutes * 60"
let seconds="$runtime - $remainder"
let rate="$runtime / $numFiles"

echo $minutes minutes and $seconds seconds to check $numFiles Go files
echo which is about $rate seconds per file
