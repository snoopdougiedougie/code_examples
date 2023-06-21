@echo off
REM Use this batch file to zip up the Go files (*.go) into main.zip and replace the source for a Lambda function.

REM Make sure we have a Lambda function name

if "%1"=="" goto noargs

aws cloudformation describe-stacks --stack-name %1 --query Stacks[0].Outputs --output text
goto end

:noargs
echo You must supply the name of a CloudFormation stack

:end
