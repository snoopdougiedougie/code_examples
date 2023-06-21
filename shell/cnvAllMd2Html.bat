@echo off
REM Creates a copy of all of the Markdown (MD) files in %1 to HTML
REM *.md -> *.html

REM Make sure we have an arg
IF [%1] == [] GOTO NOARGS

pushd %1

for %%f in (*.md) do (
REM    echo %%~nf
    %LOCALAPPDATA%\Pandoc\pandoc.exe -f markdown -t html "%%~nf.md" > "%%~nf.html"
)

popd

echo %1
goto END

:NOARGS
echo 1

:END
