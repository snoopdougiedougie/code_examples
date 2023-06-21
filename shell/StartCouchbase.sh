#!/usr/bin/bash

# pushd ???
echo Starting Couchbase Local
echo Press Ctrl-C to quit

# Set the environment variable CB_USER to your user name
# and the environment variable CB_PWD to your user's password
export CB_USER="Administrator"
export CB_PWD="ginger"

docker run -t --name db -p 8091-8096:8091-8096 -p 11210-11211:11210-11211 couchbase/server:enterprise-7.1.0
