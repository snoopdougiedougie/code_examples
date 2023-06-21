@echo off
REM Batch file for testing TypeScript apps in aws-doc-sdk-samples GitHub repo
REM https://github.com/awsdocs/aws-doc-sdk-examples

set test-dir=D:\TEST_HOME
set clear=
set verbose=

:loop
IF NOT "%1"=="" (
    IF "%1"=="-v" (
        echo Verbose output enabled
        SET verbose=1
    ) else IF "%1"=="-t" (
        SET test-dir=%2
        SHIFT
    ) else IF "%1"=="-c" (
        SET clear=1
    ) else (
        echo Unknown command
        goto :USAGE
    )

    SHIFT
    GOTO :loop
)

IF DEFINED %clear (
    IF DEFINED %verbose (
        echo Deleting %test-dir%
	pause
    )

    rmdir /s /q %test-dir%
)

set cdk-dir=%test-dir%\CDK_TEST
set examples-dir=%test-dir%\aws-doc-sdk-examples

REM Create the directories if they do not exist
REM and populate them as appropriate
IF DEFINED %verbose (
    echo Checking for %test-dir%
    pause
)

IF NOT EXIST %test-dir% (
    IF DEFINED %verbose (
        echo Creating %test-dir%
	pause
    )

    mkdir %test-dir%
)

pushd %test-dir%

IF DEFINED %verbose (
    echo Checking for %cdk-dir%
    pause
)

IF NOT EXIST %cdk-dir% (
    IF DEFINED %verbose (
        echo Creating %cdk-dir%
	pause
    )

    mkdir %cdk-dir%

    REM Create new CDK app there
    cd %cdk-dir%
    cdk init -l typescript

    IF DEFINED %verbose (
        echo Deleting %cdk-dir%\bin\*.*
        pause
    )

    del /q %cdk-dir%\bin\*.*
    
    IF DEFINED %verbose (
        echo Finished deleting
        pause
    )

    goto :NEXT 
)

:NEXT

echo two
