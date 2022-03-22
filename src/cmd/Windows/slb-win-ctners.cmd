::slb-win-ctners.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Container services installer.
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

PUSHD "%~dp0"
DIR /B %SystemRoot%\servicing\Packages\*containers*.mum >containers.txt
FOR /F %%i IN ('findstr /i . containers.txt 2^>nul') DO dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
DEL containers.txt
Dism /online /enable-feature /featurename:Containers -All /LimitAccess /ALL

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Container services installer.
::
::   slb-win-ctners.ps1 [-v] [/?]
::   -v         Shows the batch version
::   /?         Shows this help
