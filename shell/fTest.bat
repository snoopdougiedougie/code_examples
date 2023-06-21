@echo off

set srcDir=
set tmpDir=

:loop
IF NOT "%1"=="" (
    IF "%1"=="-d" (
        echo Debugging enabled
        SET debug=%1
    ) else IF "%1"=="-s" (
        SET srcDir=%2
        SHIFT
    ) else IF "%1"=="-t" (
        SET tmpDir=%2
        SHIFT
    ) else (
        echo Unknown command
        goto USAGE
    )

    SHIFT
    GOTO :loop
)

REM Make sure we have a source folder
IF NOT DEFINED %srcDir (
    echo Source folder was not set
   
    GOTO END
) else (
   IF DEFINED %debug (
      echo Source folder was set to %srcDir% 1>&2
   )
)

IF NOT DEFINED %tmpDir (
    echo Temp folder was not set
   
    GOTO END
) else (
   IF DEFINED %debug (
      echo Temp folder was set to %tmpDir% 1>&2
   )
)

if exist %srcDir%\..\antfiles (
   echo Copying %srcDir%\..\antfiles to %tmpDir%\antfiles
   xcopy %srcDir%\..\antfiles %tmpDir%\antfiles    /c /d /e /h /i /r /y  1> NUL 2>&1
) else (
   echo Cannot find %srcDir%\..\antfiles
   goto END
)

if exist %srcDir%\..\shared (
   echo Copying %srcDir%\..\shared to %tmpDir%\shared
   xcopy %srcDir%\..\shared   %tmpDir%\shared      /c /d /e /h /i /r /y  1> NUL 2>&1
) else (
   echo Cannot find %srcDir%\..\shared
   goto END
)

if exist %srcDir%\images (
   echo Copying %srcDir%\images to %tmpDir%\%T%\images
   xcopy %srcDir%\images      %tmpDir%\%T%\images  /c /d /e /h /i /r /y  1> NUL 2>&1
) else (
   echo Cannot find %srcDir%\images
)

if exist %srcDir%\build.xml (
   echo Copying %srcDir%\build.xml to %tmpDir%\%T%
   xcopy %srcDir%\build.xml   %tmpDir%\%T%  /c /d /e /h /r /y 1> NUL 2>&1
) else (
   echo Cannot find %srcDir%\build.xml
)

if exist %srcDir%\book.xml (
   echo Copying %srcDir%\book.xml to %tmpDir%\%T%
   xcopy %srcDir%\book.xml    %tmpDir%\%T%         /c /d /e /h /r /y 1> NUL 2>&1
) else (
   echo Cannot find %srcDir%\book.xml
)

:END
