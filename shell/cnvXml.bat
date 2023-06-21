@echo off
REM Creates a copy of all of the Zonbook (XML) files in %1 to RST
REM *.xml -> *.html

REM Make sure we have an arg
IF [%1] == [] GOTO NOARGS

pushd %1

for %%f in (*.xml) do (
    echo Converting %%~nf.xml
    awssphinx zb2rst "%%~nf.xml"
)

popd

goto END

:NOARGS
echo You need to provide a folder

:END
