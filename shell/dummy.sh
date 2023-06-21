#!/usr/bin/bash
runtime=951
pushd $SOURCE_DIR
extension="${EXTENSION}"
masterList="${extension}_masterList.txt"
echo The master list is:
echo $masterList

numFiles=`cat $masterList | wc -l`

echo That took $runtime seconds to check $numFiles files
let rate="$runtime / $numFiles"
echo or about $rate seconds per file

# Say runtime = 100
# minutes = 100/60, or 1
# remainder = 60
# seconds = 40

let minutes="$runtime / 60"
echo minutes is $minutes

let remainder="$minutes * 60"
let seconds="$runtime - $remainder"

echo seconds is $seconds
