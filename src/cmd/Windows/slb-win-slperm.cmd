::slb-win-slperm.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Add Symlink permissions to Local Security Policy.
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::
:: Remarks:
::   Inspired by
::     -> https://www.tutorialspoint.com/how-to-run-a-powershell-script-from-the-command-prompt
::......................................................................................................................

::..................................................................................
:: The main entry point for the script
::
@ECHO OFF
SETLOCAL EnableDelayedExpansion

:: default help
CALL slb-helper "%~f0" "%~1" & IF DEFINED -help GOTO :eof

PowerShell -command "slb-win-slperm.ps1"

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Add Symlink permissions to Local Security Policy.
::
::   slb-win-slperm.ps1 [-i] [-u] [-v] [/?]
::   -v         Shows the batch version
::   /?         Shows this help