@echo off

echo To NOT re-create aws-doc-sdk-examples from GitHub repo
echo press Ctrl-C otherwise
pause

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

pushd %test-dir%

IF DEFINED %clear (
    IF DEFINED %verbose (
        echo Deleting aws-doc-sdk-examples
	pause
    )

    rmdir /s /q %test-dir%\aws-doc-sdk-examples 2> nul
)

REM Re-create aws-doc-sdk-examples
IF NOT EXIST aws-doc-sdk-examples\NUL mkdir aws-doc-sdk-examples

cd aws-doc-sdk-examples

call git init

call git config core.sparseCheckout true

REM Get the CDK JavaScript and TypeScript examples
echo javascript/example_code/cdk/ >> .git\info\sparse-checkout
echo typescript/example_code/cdk/ >> .git\info\sparse-checkout

call git remote add -f origin https://github.com/awsdocs/aws-doc-sdk-examples.git

call git pull origin master

popd
