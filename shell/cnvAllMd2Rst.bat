@echo off
REM Creates a copy of all of the Markdown (MD) files in %1 to RST
REM *.md -> *.rst

REM Make sure we have an arg
IF [%1] == [] GOTO NOARGS

pushd %1

for %%f in (*.md) do (
REM    echo %%~nf
    %LOCALAPPDATA%\Pandoc\pandoc.exe -f markdown -t rst "%%~nf.md" > "%%~nf.rst")

popd

echo %1
goto END

:NOARGS
echo 1

:END
