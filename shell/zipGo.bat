@echo off
REM Use this batch file to zip up the provided Go file (file.go) into a ZIP file (file.zip) that Lambda understands.

REM Make sure we have a correct filename
REM echo Got source file %1%

for /F "delims=" %%i in ("%1") do set basename=%%~ni

REM echo Basename: %basename%

REM Now make sure they gave us file.go:
if exist %basename%.go (
    echo Creating ZIP file %basename%.zip
	
    set GOOS=linux
    set GOARCH=amd64
    set CGO_ENABLED=0
    go build -o %basename% %basename%.go
    C:\bin\build-lambda-zip.exe -o %basename%.zip %basename%
) else (
    echo File %basename%.go does not exist
)
