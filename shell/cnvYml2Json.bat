@echo off
REM Converts the YML input file into JSON on stdout
ruby -ryaml -rjson -e 'puts JSON.pretty_generate(YAML.load(ARGF))' < %1
