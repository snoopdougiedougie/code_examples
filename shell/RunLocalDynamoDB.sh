#! /usr/bin/bash
pushd /c/misc/DynamoDBLocal
java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb -inMemory
