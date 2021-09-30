::slb-symlnk.cmd
::......................................................................................................................
:: Description:
::   Wrapper that invokes slb-symlnk.sh
::......................................................................................................................
@ECHO OFF
SETLOCAL

SET -script=-sh:"%ScriptLib%\src\sh\System\%0.sh"

:: boilerplate
CALL slb-helper "%~f0" "%~1" >NUL
IF DEFINED -help SET -args=-arg:%-help%
IF NOT DEFINED -help SET -args=%*
CALL slb-wrappr %-script% %-args%

ENDLOCAL & GOTO :eof