@echo off
REM Takes ownership of the specified folder and its contents

for /F "delims=" %%i in ("%1") do set name=%%~ni

if exist %name% (
    
) else (
    echo Folder %name% does not exist
)
