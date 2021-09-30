::slb-git-struct.cmd
::......................................................................................................................
:: Description:
::   Wrapper that invokes slb-git-struct.sh
::......................................................................................................................
@ECHO OFF
SETLOCAL

:: boilerplate
SET -script=-sh:"%ScriptLib%\src\sh\Git\%0.sh"
CALL slb-helper "%~f0" "%~1" >NUL
IF DEFINED -help SET -args=-arg:%-help%
IF NOT DEFINED -help SET -args=%*
CALL slb-git-wrappr %-script% %-args%

ENDLOCAL & GOTO :eof