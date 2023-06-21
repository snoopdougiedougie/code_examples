@echo off
:: Check WMIC is available
WMIC.EXE Alias /? >NUL 2>&1 || GOTO s_error

:: Use WMIC to retrieve date and time
FOR /F "skip=1 tokens=1-6" %%G IN ('WMIC Path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') DO (
   IF "%%~L"=="" goto s_done
      Set _yyyy=%%L
      Set _mm=00%%J
      Set _dd=00%%G
)
:s_done

:: Pad digits with leading zeros
      Set _mm=%_mm:~-2%
      Set _dd=%_dd:~-2%

Set datestamp=%_yyyy%-%_mm%-%_dd%
goto make_name

:s_error
echo WMIC is not available, so add date stamp manually
Set datestamp=

:make_name
set FILENAME=backup_%datestamp%.pst
echo %FILENAME%
:end
