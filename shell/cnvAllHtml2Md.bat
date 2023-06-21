@echo off
REM Creates a copy of all of the HTML files in %1 as markdown (MD) files
REM *.html -> *.md

REM Make sure we have an arg
IF [%1] == [] GOTO NOARGS

pushd %1

for %%f in (*.html) do (
REM   pandoc.exe -f html -t markdown "%%~nf.html" > "%%~nf.md"
      html2text.py "%%~nf.html" > "%%~nf.md"
)

popd

echo %1
goto END

:NOARGS
echo 1

:END
