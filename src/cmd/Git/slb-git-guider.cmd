::slb-git-guider.cmd
::......................................................................................................................
:: Description:
::   Wrapper that invokes slb-git-guider.sh
::......................................................................................................................
@ECHO OFF
SETLOCAL

SET -script=-sh:"%ScriptLib%\src\sh\Git\slb-git-guider.sh"

:: default help
CALL slb-helper "%~f0" "%~1" >NUL
IF DEFINED -help SET -args=-arg:%-help%

:: parse the arguments
IF NOT DEFINED -help CALL slb-argadd %*

:: invoke the script
CALL slb-git-wrappr %-script% %-args%

ENDLOCAL & GOTO :eof