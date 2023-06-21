#!/usr/bin/bash
# The test gives us better info
#  start=`date +%s`

# The local root of the Go examples in the aws-doc-sdk-examples GitHub repo
# For Git Bash for Windows:
srcDir=/c/GitHub/aws-doc-sdk-examples/gov2
# For cygwin:
#   srcDir=/cygdrive/d/src/aws-doc-sdk-examples/go/example_code

# The local directory where we format the source file and run the associated test
# For Git Bash for Windows:
destDir=/c/Temp/go_tests
# for cygwin:
#destDir=/cygdrive/d/tmp/go_tests

# Make sure both directories exist
if [ -e $srcDir ]
then
    echo "Found source directory $srcDir"
else
    echo "Could not find $srcDir"
    exit
fi

# Clear out destination directory if it exists
if [ -d "$destDir" ]; then
    rm -rf $destDir
fi

mkdir $destDir

# Create environment variables for region and log file name
export region="us-west-2"
export logFile="$destDir/info.log"
rm $logFile
touch $logFile

# Builds each Go example in $srcDir

# Prep destination directory
rm -rf $destDir
mkdir $destDir

# Navigate to src directory
pushd $srcDir

masterList="go_masterList.txt"

# Delete any old master list
rm $masterList
touch $masterList

# Create the list of go test files
find . -type f -name *_test.go -print >> $masterList
#numFiles=`wc -l $masterList`
numFiles=$(< "$masterList" wc -l)

# temp file for expanding tabs
tmp=$$.txt

for i in `cat $masterList`
do    
    # $i looks like:
    #     ./s3/crud/s3_crud_ops_test.go
    origSrcFile=`echo $i | sed s/_test//`
    # $origSrcFile looks like:
    #     ./s3/crud/s3_crud_ops.go
    dirName=`dirname $i`
    # $dirName looks like:
    #     ./s3/crud

    # Copy everything in source directory
    allFiles=${dirName}/*.*
    cp $allFiles $destDir 2> /dev/nul

    pushd $destDir
    
    f=`basename $i`
    # $f looks like:
    #     s3_crud_ops_test.go
    # Get the local source file
    srcFile=`echo $f | sed s/_test//`
    # $srcFile looks like:
    #     s3_crud_ops.go
    e=`basename $f .go`.exe
    # $e is the output of go build, and looks like:
    #     s3_crud_ops_test.exe
    echo Building $f  >> $logFile 2>&1
    # Make sure source file is idiomatic
    go fmt $srcFile
    expand --tabs=4 $srcFile > $tmp
    mv $tmp $srcFile
    go build $srcFile >> $logFile 2>&1

    # Run unit test
    go test >> $logFile 2>&1
    
    # Copy source file back to source
    cp $srcFile $srcDir/$origSrcFile
    rm *.go *.exe *.json *.md 2> /dev/nul
    
    popd
done

echo ""

popd
# Delete master list
rm $srcDir/$masterList

# The test gives us better info
#  end=`date +%s`
#  runtime=$((end-start))

#  echo That took $runtime seconds to run

#  let minutes="$runtime / 60"
#  let remainder="$minutes * 60"
#  let seconds="$runtime - $remainder"
#  let rate="$runtime / $numFiles"

#  echo $minutes minutes and $seconds seconds to check $numFiles Go files
#  echo which is about $rate seconds per file
