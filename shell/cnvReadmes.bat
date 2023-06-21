@echo off
REM Use this batch file to convert all of the MD files in the current folder to HTML
echo To convert all of the MD files in the current folder to HTML press ENTER
echo Otherwise press Ctrl-C to abort
pause

for %%f in (*.md) do (
    REM echo Converting %%f to HTML
    call C:\bin\cnvMd.bat %%f
    )
)
