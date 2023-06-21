@echo off
REM Converts the HTML input file to Markdown (.MD)
pandoc -f html -t markdown %1
