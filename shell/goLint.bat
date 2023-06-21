@echo off
REM Runs go version of lint on all go code in current folder
echo To run the Go version of lint against:

echo.
dir /b *.go
echo.

echo or press Ctrl-C to quit

pause

%GOPATH%\bin\gometalinter .

echo Done
