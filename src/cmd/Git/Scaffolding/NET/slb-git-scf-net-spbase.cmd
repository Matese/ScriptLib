::slb-git-scf-net-spbase.cmd
::......................................................................................................................
:: Description:
::   Wrapper that invokes slb-git-scf-net-spbase.sh
::......................................................................................................................
@ECHO OFF
SETLOCAL

:: boilerplate
CALL slb-helper "%~f0" "%~1" >NUL
IF DEFINED -help SET -args=-arg:%-help%
IF NOT DEFINED -help SET -args=%*
SET -script=-sh:"%~dp0%0.sh"
CALL slb-wrappr %-script% %-args%

ENDLOCAL & GOTO :eof