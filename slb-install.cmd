::slb-install.cmd Version 0.1
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
::     -> https://stackoverflow.com/questions/35560540/batch-file-to-list-directories-recursively-in-windows-as-in-linux
::     -> https://stackhowto.com/batch-file-to-read-text-file-line-by-line-into-a-variable/
::     -> https://stackoverflow.com/questions/14588785/how-do-i-add-to-beginning-using-text-file-using-a-bat-instead-of-append-to-end
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
IF NOT DEFINED -q ECHO Installing ScriptLib...

:: uninstall quietly
CALL %~dp0slb-uninstall -q

:: set environment variables
CALL :setEnvVars %-q%

:: set aliases
CALL :setAliases

:: if not quiet
IF NOT DEFINED -q ECHO Done!
IF NOT DEFINED -q PAUSE

ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Set ScriptLib environment variables
::
:setEnvVars
    SETLOCAL

    :: ScriptLib dir
    SET -dir=%~dp0src

    SETLOCAL EnableDelayedExpansion
    FOR /F %%f in ('DIR /A:D /S /B /O:N "%-dir%"') DO set -slb=!-slb!%%f;
    SETLOCAL DisableDelayedExpansion

    :: path
    SET -path=%-path%%%ScriptLib%%;

    :: set environment variables
    SETX ScriptLib "%-slb%" >NUL
    SETX PATH "%-path%" >NUL

    :: if not quiet
    if "%1"=="" (
        ECHO.
        ECHO User variables:
        ECHO.
        ECHO %-path%
        ECHO.
    )

    ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Set ScriptLib aliases
::
:setAliases
    SETLOCAL

    SET -f="%HOMEDRIVE%%HOMEPATH%\.bash_profile"

    :: create file if not exist
    IF NOT EXIST %-f% TYPE NUL>%-f%

    :: create new temp file
    SET -t="%TEMP%\temp_file.tmp"
    DEL %-t% 2>nul
    TYPE NUL>%-t%

    :: copy existing file to a temporary file
    COPY %-f% %-t% 1>nul

    :: create new file
    DEL %-f% 2>nul
    TYPE NUL>%-f%

    :: get current encoding and then change it to UTF8
    FOR /f "tokens=2 delims=:." %%x IN ('chcp') DO SET cp=%%x
    CHCP 65001 >nul

    SETLOCAL EnableDelayedExpansion

:: newline hack
(SET LF=^
%=EMPTY=%
)

    :: create content variable
    set -content=!-content!#..................................................................................!LF!>> !-f!
    set -content=!-content!# ScriptLib!LF!>> !-f!
    set -content=!-content!!LF!>> !-f!
    set -content=!-content!# Aliases!LF!>> !-f!
    set -content=!-content!alias slb=\'slb.sh\'!LF!>> !-f!
    set -content=!-content!!LF!>> !-f!
    set -content=!-content!#..................................................................................!LF!>> !-f!

    :: write content variable to file
    ECHO !-content!>> !-f!

    SETLOCAL DisableDelayedExpansion

    :: set old encoding
    CHCP %cp% >nul

    :: append content of temp file
    FOR /F %%i IN (%-t:"=%) DO ECHO %%i >> %-f%

    :: remove tempfile
    DEL %-t%

    ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Install ScriptLib (Modifies environment variables in the user environment)
::
::   slb-install [-q] [-v] [/?]
::   -q         Quiet
::   -v         Shows the batch version
::   /?         Shows this help