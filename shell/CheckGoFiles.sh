#!/usr/bin/bash
# The test gives us better info
#  start=`date +%s`

# The local directory of the Go files
# For Git Bash for Windows:
srcDir=/c/languages/go/test/v2
# For cygwin:
#   srcDir=/cygdrive/c/...

# The local directory where we format the source file and run the associated test
# For Git Bash for Windows:
destDir=/c/Temp/go_tests
# for cygwin:
#destDir=/cygdrive/c/...

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
    rm -rf $destDir 2> /dev/nul
fi

mkdir $destDir

# Create environment variables for region and log file name
export region="us-west-2"
export logFile="$destDir/info.log"
rm $logFile 2> /dev/nul
touch $logFile

# Builds each Go example in $srcDir

# Prep destination directory
echo Creating $destDir
rm -rf $destDir 2> /dev/nul
mkdir $destDir

# Navigate to src directory
pushd $srcDir

masterList="go_masterList.txt"

# Delete any old master list
rm $masterList 2> /dev/nul
touch $masterList

# Create the list of go test files
find . -type f -name *.go -print >> $masterList
#numFiles=`wc -l $masterList`
numFiles=$(< "$masterList" wc -l)

# temp file for expanding tabs
tmp=$$.txt

for i in `cat $masterList`
do
    echo Processing $i
    # $i looks like:
    #     ./s3/crud/s3_crud_ops.go
    
    dirName=`dirname $i`
    # $dirName looks like:
    #     ./s3/crud

    echo In directory $dirName

    # Copy everything in source directory
    allFiles=${dirName}/*.*

    echo Copying all of the files to $destDir
    cp $allFiles $destDir

    pushd $destDir
    
    f=`basename $i`
    # $f looks like:
    #     s3_crud_ops.go

    echo Building $f
    echo Building $f  >> $logFile 2>&1

    # Make sure source file is idiomatic
    echo Formatting $f
    go fmt $f
    expand --tabs=4 $f > $tmp
    mv $tmp $f
    go build $f >> $logFile 2>&1
    go vet $f >> $logFile 2>&1
    golangci-lint run $f >> $logFile 2>&1    

    # Copy source file back to source
    cp $f $srcDir/$i
    
    popd
done

echo ""

popd
# Delete master list
rm $srcDir/$masterList 2> /dev/nul

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
