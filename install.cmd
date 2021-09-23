::install Version 0.1
::......................................................................................................................
:: Description:
::   Install ScriptLib
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

ECHO Installing ScriptLib...

:: ScriptLib dir
SET -slb=%~dp0

:: remove last character (it is a Backslash)
SET -slb=%-slb:~0,-1%

:: go to System directory
CD %~dp0%\src\cmd\System

:: https://stackoverflow.com/questions/3583565/how-to-skip-pause-in-batch-file
ECHO | CALL %~dp0uninstall >NUL

:: add ScriptLib environment variables to -path variable
SET -cmd=%%ScriptLib%%\src\cmd\
SET -path=%-path%%-cmd%Git;
SET -path=%-path%%-cmd%System;
SET -path=%-path%%-cmd%Tips;
SET -path=%-path%%-cmd%Windows;
SET -sh=%%ScriptLib%%\src\sh\
SET -path=%-path%%-sh%Git;
SET -path=%-path%%-sh%Linux;
SET -path=%-path%%-sh%System;

:: set environment variables
SETX ScriptLib "%-slb%" >NUL
SETX PATH "%-path%" >NUL

ECHO.
ECHO User variables:
ECHO.
ECHO %-path%
ECHO.
ECHO Done!

PAUSE

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Install ScriptLib (Modifies environment variables in the user environment)
::
::   install [-v] [/?]
::   -v         Shows the batch version
::   /?         Shows this help