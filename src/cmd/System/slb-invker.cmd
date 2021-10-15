::slb-git-invker.cmd
::......................................................................................................................
:: Description:
::   Wrapper that invokes sh scripts
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release
::......................................................................................................................

::..................................................................................
:: The main entry point for the script
::
@ECHO OFF
SETLOCAL

:: boilerplate
CALL slb-helper "%~f0" "%~1" >NUL
IF DEFINED -help SET -args=-arg:%-help%
IF NOT DEFINED -help SET -args='%*'
SET -script=-sh:"%~dp0%0.sh"
CALL slb-wrappr %-script% %-args%

ENDLOCAL & GOTO :eof