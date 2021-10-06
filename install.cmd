::install.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Install ScriptLib
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::
:: Remarks:
::   Modifies environment variables in the user environment
::
::   Inspired by
::     -> https://www.tutorialspoint.com/batch_script/batch_script_aliases.htm
::     -> https://stackoverflow.com/questions/59393482/how-to-make-an-alias-for-a-function-in-batch
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

ECHO Installing ScriptLib...

:: uninstall quietly
CALL %~dp0uninstall -q

:: set environment variables
CALL :setEnvVars

:: set aliases
CALL :setAliases

ECHO Done!

ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Set ScriptLib environment variables
::
:setEnvVars
    SETLOCAL

    :: cmd
    SET -cmd=%%ScriptLib%%\src\cmd\
    SET -path=%-path%%-cmd%Git;
    SET -path=%-path%%-cmd%NET;
    SET -path=%-path%%-cmd%System;
    SET -path=%-path%%-cmd%Windows;

    :: ps1
    SET -ps1=%%ScriptLib%%\src\ps1\
    SET -path=%-path%%-ps1%Windows;
    SET -path=%-path%%-ps1%System;

    :: sh
    SET -sh=%%ScriptLib%%\src\sh\
    SET -path=%-path%%-sh%Git;
    SET -path=%-path%%-sh%Linux;
    SET -path=%-path%%-sh%NET;
    SET -path=%-path%%-sh%System;

    :: ScriptLib dir
    SET -slb=%~dp0

    :: remove last character (it is a Backslash)
    SET -slb=%-slb:~0,-1%

    :: set environment variables
    SETX ScriptLib "%-slb%" >NUL
    SETX PATH "%-path%" >NUL

    ECHO.
    ECHO User variables:
    ECHO.
    ECHO %-path%
    ECHO.

    ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Set ScriptLib aliases
::
:setAliases
    SETLOCAL

    SET -f="%HOMEDRIVE%%HOMEPATH%\.bash_profile"

    :: create file if not exist
    IF NOT EXIST %-f% TYPE NUL>%-f%

    :: get current encoding and then change it to UTF8
    FOR /f "tokens=2 delims=:." %%x IN ('chcp') DO SET cp=%%x
    CHCP 65001 >nul

    SETLOCAL EnableDelayedExpansion

:: newline hack
(SET LF=^
%=EMPTY=%
)

    :: create content variable
    set -content=!-content!# ScriptLib!LF!>> !-f!
    set -content=!-content!alias slb=\'slb.sh\'!LF!>> !-f!

    :: write content variable to file
    ECHO !-content!>> !-f!

    SETLOCAL DisableDelayedExpansion

    :: set old encoding
    CHCP %cp% >nul

    ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Install ScriptLib (Modifies environment variables in the user environment)
::
::   install [-v] [/?]
::   -v         Shows the batch version
::   /?         Shows this help