@echo off
REM Creates a copy of all of the reStructuredText (RST) files in %1 to HTML
REM *.rst -> *.html

REM Make sure we have an arg
IF [%1] == [] GOTO NOARGS

pushd %1

for %%f in (*.rst) do (
REM    echo %%~nf
    %LOCALAPPDATA%\Pandoc\pandoc.exe -f rst -t html "%%~nf.rst" > "%%~nf.html"
)

popd

echo %1
goto END

:NOARGS
echo 1

:END
