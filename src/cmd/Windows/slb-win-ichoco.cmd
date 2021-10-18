::slb-win-ichoco.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Chocolatey package manager installer.
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

:: parse the arguments
CALL slb-argadd %*

IF DEFINED -i SET arg="-i"
IF DEFINED -u SET arg="-u"

PowerShell -command "slb-win-ichoco.ps1" %arg%

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Chocolatey package manager installer.
::
::   slb-win-ichoco.ps1 [-i] [-u] [-v] [/?]
::   -i         Install
::   -u         Uninstall
::   -v         Shows the batch version
::   /?         Shows this help
