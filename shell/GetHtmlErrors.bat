@echo off
REM Runs tidy on all HTML files in the current folder
REM echo Running tidy in %CD%

set tidy=\misc\tidy-5.2.0-win64\bin\tidy.exe

set tmpfile=mytempfile

for %%f in (*.html) do (
    echo %%f

    REM Delete ERR file if it exists
    if exist "%%~nf.err" del "%%~nf.err"

    %tidy% "%%~nf.html" > %tmpfile% 2> "%%~nf.err"
    del %tmpfile%
)

echo.
echo Search ERR files for any errors
