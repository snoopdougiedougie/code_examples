@echo off
REM Use this batch file to zip up the Go files (*.go) into main.zip and replace the source for a Lambda function.

REM Make sure we have a Lambda function name

if not "%1"=="" (
    set GOOS=linux
    set GOARCH=amd64
    set CGO_ENABLED=0
    go build -o main
    build-lambda-zip.exe -o main.zip main
    aws lambda update-function-code --function-name %1 --zip-file fileb://main.zip
) else (
    echo You must supply the name of a Lambda function
)
