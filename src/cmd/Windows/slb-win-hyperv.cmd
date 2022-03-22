::slb-win-hyperv.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Hyper-V services installer.
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
DIR /B %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hyper-v.txt
FOR /F %%i in ('findstr /i . hyper-v.txt 2^>NUL') DO dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
DEL hyper-v.txt
Dism /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Hyper-V services installer.
::
::   slb-win-hyperv.ps1 [-v] [/?]
::   -v         Shows the batch version
::   /?         Shows this help
