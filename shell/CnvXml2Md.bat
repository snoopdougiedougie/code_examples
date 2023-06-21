@echo off
REM Creates Markdown (MD) files from Zonbook (XML) files

REM Make sure these variables are unset at first

REM Set to true to barf out some debugging info
set debug=

REM Set to the location of the source ZonBook/XML files
set srcDir=

REM Set to where the temporary files are stored
set tmpDir=

REM Set to where the "ant html" output ends up
set outDir=

:loop
IF NOT "%1"=="" (
    IF "%1"=="-d" (
        echo Debugging enabled
        SET debug=%1
    ) else IF "%1"=="-t" (
        SET tmpDir=%2
        SHIFT
    ) else IF "%1"=="-o" (
        SET outDir=%2
        SHIFT
    ) else IF "%1"=="-s" (
        SET srcDir=%2
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
    GOTO USAGE
)

REM Make sure we have a temp folder
IF NOT DEFINED %tmpDir (
    echo Temp folder was not set
    GOTO USAGE
)

REM Make sure we have an output folder
IF NOT DEFINED %outDir (
    echo Output folder was not set
    GOTO USAGE
)

REM Barf out our paths
IF DEFINED %debug (
   echo.
   echo Source folder was set to %srcDir% in CnvXml2Md.bat 1>&2
   echo Temp folder was set to   %tmpDir% in CnvXml2Md.bat 1>&2
   echo Output folder was set to %outDir% in CnvXml2Md.bat 1>&2
   echo.
)

REM Merge sections into chapters in XML files
set MERGE=%RubySource%\MergeSectionsIntoChapter.rb
set CNV=%BIN%\cnvAllHtml2Md.bat
set RmDisc=%RubySource%\RmDisclaimer.rb

REM merge only returns the folder name,
IF DEFINED %debug (
   echo Running %MERGE% -d -s %srcDir% -t %tmpDir% -o %outDir %1>&2

   for /f %%i in ('%RUBY% %MERGE% -d -s %srcDir% -t %tmpDir% -o %outDir%') do set T=%%i
) else (
   for /f %%i in ('%RUBY% %MERGE% -s %srcDir% -t %tmpDir% -o %outDir%') do set T=%%i
)

REM If MERGE returns 1, it means it failed
if "%T%"=="1" (
   echo MergeSectionsIntoChapter.rb failed 1>&2
   goto FAIL
)

set mdDir=%outDir%\%tmpDir%\%T%

IF DEFINED %debug (
   echo Set output folder as %mdDir%
)

REM Copy source files to build folder
if exist %srcDir%\..\antfiles (
   IF DEFINED %debug (
      echo Copying %srcDir%\..\antfiles to %tmpDir%\antfiles
   )
   
   xcopy %srcDir%\..\antfiles %tmpDir%\antfiles    /c /d /e /h /i /r /y  1> NUL 2>&1
) else (
   echo Cannot find %srcDir%\..\antfiles
   goto FAIL
)

if exist %srcDir%\..\shared (
   IF DEFINED %debug (
      echo Copying %srcDir%\..\shared to %tmpDir%\shared
   )
   
   xcopy %srcDir%\..\shared   %tmpDir%\shared      /c /d /e /h /i /r /y  1> NUL 2>&1
) else (
   echo Cannot find %srcDir%\..\shared
   goto FAIL
)

if exist %srcDir%\images (
   IF DEFINED %debug (
      echo Copying %srcDir%\images to %tmpDir%\%T%\images
   )
   
   xcopy %srcDir%\images      %tmpDir%\%T%\images  /c /d /e /h /i /r /y  1> NUL 2>&1
) else (
   echo Cannot find %srcDir%\images
   goto FAIL
)

if exist %srcDir%\build.xml (
   IF DEFINED %debug (
      echo Copying %srcDir%\build.xml to %tmpDir%\%T%
   )
   
   xcopy %srcDir%\build.xml   %tmpDir%\%T%  /c /d /e /h /r /y 1> NUL 2>&1
) else (
   echo Cannot find %srcDir%\build.xml
   goto FAIL
)

if exist %srcDir%\book.xml (
   IF DEFINED %debug (
      echo Copying %srcDir%\book.xml to %tmpDir%\%T%
   )
   
   xcopy %srcDir%\book.xml    %tmpDir%\%T%         /c /d /e /h /r /y 1> NUL 2>&1
) else (
   echo Cannot find %srcDir%\book.xml
   goto FAIL
)

REM Build HTML files
IF DEFINED %debug (
    echo Navigating to %tmpDir%\%T% 1>&2
)

pushd %tmpDir%\%T%

del antBuild.txt 1> NUL 2>&1

IF DEFINED %debug (
    echo Running ant html 1>&2
)

call ant html 1> antBuild.txt 2>&1

popd

REM Remove SEARegionDisclaimer div from HTML files
IF DEFINED %debug (
   echo Running %RmDisc% -d %mdDir %1>&2

   for /f %%i in ('%RUBY% %RmDisc% -d %mdDir%') do set T=%%i
) else (
   for /f %%i in ('%RUBY% %RmDisc% -s %mdDir%') do set T=%%i
)

REM If RmDisclaimer returns 1, it means it failed
if "%T%"=="1" (
   echo RmDisclaimer.rb failed 1>&2
   goto FAIL
)

REM Convert all the HTML files in the output folder to MD files
IF DEFINED %debug (
   echo Running %CNV% %outDir%\%tmpDir%\%T% 1>&2
)

for /f %%i in ('%CNV% %outDir%\%tmpDir%\%T%') do set T=%%i

REM If CNV returns 1, it means it failed
if "%T%"=="1" (
   echo Conversion from HTML to MD failed 1>&2
   goto FAIL
)

echo The markdown files are in %mdDir%

goto END

:USAGE
echo.
echo CnvXml2Md.bat -s source-dir -t tmp-dir -o out-dir
echo    where:
echo    source-dir    is where your ZonBook (XML) files are located
echo    tmp-dir       is where the temporary directory and files are created
echo    out-dir       is where 'ant html' creates its output
echo.

goto END

:FAIL

IF NOT DEFINED %debug (
   echo Set '-d' flag the next time to see additional information.
)

:END
