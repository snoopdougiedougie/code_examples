#!/usr/bin/bash

# The local root of the Go examples in the aws-doc-sdk-examples GitHub repo
# srcDir

# The sub-directory under srcDir. If empty, we test ALL files
# language

# The local directory where we run tests
# testDir

# The branch for the PR
# branch

# Make sure both directories exist
if [ -z "$srcDir" ]
then
    echo "You must set the srcDir environment variable"
    exit
else 
    echo "Source directory: $srcDir"
fi

if [ -z "$testDir" ]
then
    echo "You must set the testDir environment variable"
    exit
else 
    echo "Test directory:   $testDir"
fi

if [ -z "$branch" ]
then
    branch=master
    echo "You didn't set the branch environment variable, using $branch"
else
    echo "Branch:           $branch"
fi

if [ -z "$language" ]
then
    echo "You didn't set the language environment variable"
else
    echo "Language:         $language"
fi

echo "If those aren't correct press Ctrl-C and set them correctly"
echo "Otherwise press enter to continue"
read line

# Make sure we get the files from branch
# First store existing branch value
pushd $srcDir
oldBranch=`git rev-parse --abbrev-ref HEAD`
echo "Stashing existing branch value $oldBranch"
echo "Checking out branch $branch"
git checkout $branch

# Create test directory if it doesn't exist
if [ ! -d "$testDir" ]; then
    echo "Creating test directory $testDir"
    mkdir $testDir
fi

# Clear out test directory
pushd $testDir > /dev/nul 2>&1
echo "Clearing out test directory"
rm -rf * > /dev/nul 2>&1

# Copy source files, tests to here
if [ -z "$language" ]
then
    echo "Copying the entire source directory"
    cp -r $srcDir .
else
    echo "Copying the $language sub-directory"
    cp -r $srcDir/$language .
fi

echo "Copying Python scripts to test directory"
cp $srcDir/scripts/*.py .

echo ""

# Check snippet tags
echo Press enter to check snippet tags
read line

python checkin_tests.py | sed /'Checking File'/d | sed /'words found'/d | sed /^$/d | sed /skipped/d

# Check metadata
echo ""
echo Press enter to check metadata
read line

python cleanup_report.py > cleanup_report.csv

pushd $srcDir
git checkout $oldBranch
popd
