#!/usr/bin/bash

echo
echo "Press enter to create a Go project from the existing GO file or Ctrl-C to quit"
read line

go mod init mymain
# go install github.com/aws/aws-sdk-go-v2/aws

echo
echo "Press enter to run go mod tidy or Ctrl-C to quit"
read line
go mod tidy

echo
echo "Press enter to vet the Go files or Ctrl-C to quit"
read line
go vet *.go

echo
echo "Press enter to run lint on the Go files or Ctrl-C to quit"
read line
golangci-lint run

echo
echo "Press enter to build the Go code or Ctrl-C to quit"
read line
go build

echo
echo "Press enter to delete the executable or Ctrl-C to quit"
read line
rm mymain.exe

echo
echo "Press enter to run the unit test and see the log output or Ctrl-C to quit"
read line
go test -v

echo
echo "You need to check in the following files (from git status):"
git status
echo
