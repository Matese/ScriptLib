::uninstall.cmd Version 0.1
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

::..................................................................................
:: The main entry point for the script
::
@ECHO OFF
SETLOCAL

:: go to System directory
SET -system=%~dp0%src\cmd\System
CD %-system%

:: default help
CALL %-system%\slb-helper "%~f0" "%~1" & IF DEFINED -help GOTO :eof

:: parse the arguments
CALL %-system%\slb-argadd %*

:: if not quiet
IF NOT DEFINED -q ECHO Uninstalling ScriptLib...

:: delete environment variables
CALL :delEnvVars %-q%

:: delete aliases
CALL :delAliases

:: if not quiet
IF NOT DEFINED -q ECHO Done!
IF NOT DEFINED -q PAUSE

:: return -path variable
CALL %-system%\slb-return -path -path

ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Delete ScriptLib environment variables
::
:delEnvVars
    :: remove environment variables
    REG delete HKCU\Environment /F /V ScriptLib >NUL 2>NUL
    CALL %-system%\slb-pthrem -opt:USER -str:+ScriptLib+ -r >NUL

    :: if not quiet
    if "%1"=="" (
        ECHO.
        ECHO User variables:
        ECHO.
        ECHO %-path%
        ECHO.
    )

    GOTO :eof

::......................................................................................................................
:: Delete ScriptLib aliases
::
:delAliases
    SETLOCAL

    SET -f="%HOMEDRIVE%%HOMEPATH%\.bash_profile"

    :: remove alias
    CALL %-system%\slb-rplcer -f:%-f% -o:"# ScriptLib" -l >NUL
    CALL %-system%\slb-rplcer -f:%-f% -o:"alias slb=\'slb.sh\'" -l >NUL

    ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Uninstall ScriptLib (Modifies environment variables in the user environment)
::
::   uninstall [-q] [-v] [/?]
::   -q         Quiet
::   -v         Shows the batch version
::   /?         Shows this help