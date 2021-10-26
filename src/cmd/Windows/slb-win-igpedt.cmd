::slb-win-igpedt.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Group policy editor installer.
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::
:: Remarks:
::   Inspired by
::     -> https://www.minitool.com/news/group-policy-editor-gpedit-msc-missing.html
::......................................................................................................................

::..................................................................................
:: The main entry point for the script
::
@ECHO OFF
SETLOCAL EnableDelayedExpansion

:: default help
CALL slb-helper "%~f0" "%~1" & IF DEFINED -help GOTO :eof

PUSHD "%~dp0"

DIR /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum >List.txt

DIR /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum >>List.txt

FOR /f %%i IN ('findstr /i . List.txt 2^>nul') DO dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"

PAUSE

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Group policy editor installer.
::
::   slb-win-igpedt.ps1 [-v] [/?]
::   -v         Shows the batch version
::   /?         Shows this help
