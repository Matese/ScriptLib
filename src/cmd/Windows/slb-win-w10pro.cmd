::slb-win-w10pro.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Windows 10 Pro registry key.
::
:: History:
::   - v0.1 2022-03-22 Initial versioned release with embedded documentation
::
:: Remarks:
::   Inspired by
::     -> https://stackoverflow.com/questions/54387049/installing-docker-on-windows-10-home-can-it-be-done
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

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /f /v EditionID /t REG_SZ /d "Professional"
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /f /v ProductName /t REG_SZ /d "Windows 10 Pro"

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Windows 10 Pro registry key.
::
::   slb-win-w10pro.ps1 [-v] [/?]
::   -v         Shows the batch version
::   /?         Shows this help
