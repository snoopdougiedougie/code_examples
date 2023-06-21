#!/usr/bin/bash
start=`date +%s`

if [ "$1" == "" ]
then
   echo You must supply a word to search for
   exit 1
fi

pushd /c/DotNet/Repos

masterList="repo_masterList.txt"
numRepos=$(< "$masterList" wc -l)

# temp file
# tmp=$$.txt

for i in `cat $masterList`
do    
    # $i looks like:
    # https://github.com/aws/aws-sdk-net
    name=`basename $i`
    # $name looks like: aws-sdk-net
    #
    echo The name is $name

    if [ -e $name ]
    then
        echo Examining $name
    else
        echo Cloning $name
        git clone $i
    fi

    pushd name
    findInFilenames.sh $1 cs
    popd
done

popd

end=`date +%s`
runtime=$((end-start))

echo That took $runtime seconds to run

let minutes="$runtime / 60"
let remainder="$minutes * 60"
let seconds="$runtime - $remainder"
let rate="$runtime / $numRepos"

echo $minutes minutes and $seconds seconds to check $numRepos repos
echo which is about $rate seconds per repo
