::slb-uninstall.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Uninstall ScriptLib
::
:: History:
::   - v0.1 2019-12-03 Initial release including basic documentation
::
:: Remarks:
::   Modifies environment variables in the user environment
::
::   Inspired by
::     -> https://stackoverflow.com/questions/32149279/how-to-read-a-specified-line-in-a-txt-file-batch
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

    :: create file if not exist
    IF NOT EXIST %-f% TYPE NUL>%-f%

    :: get the value from line 2 and line 7
    FOR /F "tokens=1,* delims=:" %%a in ('FINDSTR /n "^" %-f% ^|FINDSTR "^2:"') do (set line2=%%b)
    FOR /F "tokens=1,* delims=:" %%a in ('FINDSTR /n "^" %-f% ^|FINDSTR "^7:"') do (set line7=%%b)
    SET sline2="# ScriptLib"
    SET sline7="#.................................................................................."

    :: create new temp file
    SET -t="%TEMP%\temp_file.tmp"
    DEL %-t% 2>nul
    TYPE NUL>%-t%

    :: compare the values
    IF "%line2%" EQU %sline2% IF "%line7%" EQU %sline7% (

        :: remove alias - the first 8 lines
        FOR /F "skip=8 delims=*" %%a IN (%-f:"=%) DO (ECHO %%a>>%-t%)

        :: copy contents of temp to the file
        COPY %-t% %-f% 1>nul
    )

    :: remove tempfile
    DEL %-t%

    ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Uninstall ScriptLib (Modifies environment variables in the user environment)
::
::   slb-uninstall [-q] [-v] [/?]
::   -q         Quiet
::   -v         Shows the batch version
::   /?         Shows this help