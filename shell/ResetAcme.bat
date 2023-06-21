@echo off
echo Press enter to reset ACME
echo Otherwise Ctrl-C to quit
pause

"C:\Program Files (x86)\Quarantine\ACME-WFP.exe --reset-firewall"
"C:\Program Files (x86)\Quarantine\ACME-WFP.exe --remediate"

echo Done
