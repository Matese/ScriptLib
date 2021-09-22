::uninstall Version 0.1
::......................................................................................................................
:: Description:
::   Uninstall ScriptLib
::
:: History:
::   - v0.1 2019-12-03 Initial release including basic documentation
::
:: Remarks:
::   Modifies environment variables in the user environment
::......................................................................................................................
@ECHO OFF
SETLOCAL

:: default help
CALL %~dp0src\cmd\System\slb-helper "%~f0" "%~1" & IF DEFINED -help GOTO :EOF

ECHO Uninstalling ScriptLib...

:: variables
SET -cmd=%%ScriptLib%%\src\cmd\
SET -git=%-cmd%Git
SET -sys=%-cmd%System
SET -tps=%-cmd%Tips
SET -win=%-cmd%Windows

:: go to System directory
CD %~dp0%\src\cmd\System

:: remove environment variables
REG delete HKCU\Environment /F /V ScriptLib >NUL 2>NUL
CALL %~dp0\src\cmd\Windows\slb-win-pthrem -opt:USER -str:%-git% >NUL
CALL %~dp0\src\cmd\Windows\slb-win-pthrem -opt:USER -str:%-sys% >NUL
CALL %~dp0\src\cmd\Windows\slb-win-pthrem -opt:USER -str:%-tps% >NUL
CALL %~dp0\src\cmd\Windows\slb-win-pthrem -opt:USER -str:%-win% >NUL

ECHO.
ECHO User variables:
ECHO.
ECHO %-path%
ECHO.
ECHO Done!

PAUSE

:: return -path param
CALL slb-return -path -path
ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Uninstall ScriptLib (Modifies environment variables in the user environment)
::
::   install [-v] [/?]
::   -v         Shows the batch version
::   /?         Shows this help