@echo off
for /f "delims=" %%a in (' dir "c:\GitHub\aws-doc-sdk-examples" /ad /b /s ') do call :size "%%a"
sort /r < "dirsize.tmp"
del "dirsize.tmp"
popd
pause
goto :eof

:size
for /f "tokens=3" %%b in ('dir "%~1" 2^>nul ^|find " File(s) "') do (
for /f "tokens=1-4 delims=," %%c in ("%%b") do (
set dirsize=%%c%%d%%e%%f
)
)
set dirsize=%dirsize%
set dirsize=%dirsize:~-20%
>>"dirsize.tmp" echo %dirsize% "%~1"
