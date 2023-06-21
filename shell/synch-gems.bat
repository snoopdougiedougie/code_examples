@echo off

echo Press enter to update and clean gems or Ctrl-C to quit
pause
call gem cleanup
call gem update
call gem clean
echo.
echo Done
echo.
