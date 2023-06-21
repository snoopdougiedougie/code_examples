@echo off

rem This batch file decrypts a VBE file to the original filename + ".vbs"

rem Requires one argument, the name of the VBE file
rem so quit if no args

if "%1"=="" goto noargs

set script=c:\windows\system32\cscript.exe
set vbscript=c:\bin\decovbe.vbs
set outfile=%1.vbs

%script% %vbscript% %1 > %outfile%

echo Output was saved in %outfile%

goto :end

:noargs
echo You must supply a VBE file argument

:end