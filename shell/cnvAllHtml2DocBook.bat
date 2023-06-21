@echo off
REM Creates a copy of all of the HTML files in %1 or the current folder as a DocBook (XML) file
REM *.html -> *.xml

if "%1"=="" (
    pushd .
) else (
    pushd %1
)

for %%f in (*.html) do (
REM    echo %%~nf
    %LOCALAPPDATA%\Pandoc\pandoc.exe -s -f html -t docbook "%%~nf.html" > "%%~nf.xml"
)

popd

echo %1
