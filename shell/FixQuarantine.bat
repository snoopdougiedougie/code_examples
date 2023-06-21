@echo off
goto check_Permissions

:check_Permissions

net session >nul 2>&1

if %errorLevel% == 0 (
    echo Stopping Quarantine service
    net stop quarantine > nul

    pushd "C:\Program Files (x86)\Quarantine\State"

    echo Clearing Quarantine files
    del /F /Q *.*
    del /F /Q ServiceAgents\*.*
    rmdir ServiceAgents
    
    popd

    echo Starting Quarantine service
    net start quarantine > nul
) else (
    echo Failure: Current permissions inadequate.
)
