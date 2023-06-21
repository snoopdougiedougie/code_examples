@echo off
REM Converts the markdown input file to HTML
for /F "delims=" %%i in ("%1") do set basename=%%~ni

if exist %basename%.md (
    C:\PROGRA~1\Pandoc\pandoc.exe -f markdown -t html %1 > %basename%.html
) else (
    echo File %basename%.md does not exist
)


