#!/usr/bin/bash

# Changes:
#   snippet-start: [
# to:
#   snippet-start:[
# in all files in the current directory on down

find . -type f -exec sed -i s/"snippet-start: \["/snippet-start:\[/g {} +
