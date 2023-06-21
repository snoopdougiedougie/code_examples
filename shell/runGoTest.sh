#!/usr/bin/bash
echo "Press enter to run go test or Ctrl-C to quit"
read line

# So we can run a test


declare RESULT=(`go test`)  # (..) = array
if [ "${RESULT[0]}" == "PASS" ]
then
   echo "The test passed"
else
       echo "The test failed"
fi

