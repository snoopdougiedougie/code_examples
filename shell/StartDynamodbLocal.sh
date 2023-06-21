#!/usr/bin/bash

pushd /c/misc/dynamodb_local_latest
echo Starting DynamoDB Local
echo Press Ctrl-C to quit

java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb
