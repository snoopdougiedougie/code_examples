@echo off

REM Take in cdk_test-stack.ts
REM Return: cdk_test.ts

IF NOT "%1"=="" (
  echo Original string: %1
  set var=%1
  echo %var:~0,-9%.ts
)

