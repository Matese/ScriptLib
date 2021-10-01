::slb-helper.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Performs file documentation analysis.
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::
:: Remarks:
::   This script has the premise that the script passed as argument has the same documentation convention as this
::   script. In other words, the script passed as argument should have a ":::HELP:::" at the end of the script.
::......................................................................................................................

::..................................................................................
:: The main entry point for the script
::
@ECHO OFF
SETLOCAL

:: capture and set internal arguments
SET -arg1=-%~1-
SET -arg1=%-arg1:"=%
SET -arg2=-%~2-
SET -arg2=%-arg2:"=%

:: argument to be returned
SET "-help="

IF %-arg1%==-/?- (
    SET -p=%~f0 & CALL :showHelp & SET -help="/?"
) ELSE IF %-arg2%==-/?- (
    SET -p=%~1  & CALL :showHelp & SET -help="/?"
) ELSE IF %-arg1%==--v- (
    SET -p=%~f0 & CALL :showVersion & SET -help=-v
) ELSE IF %-arg1%==--V- (
    SET -p=%~f0 & CALL :showVersion & SET -help=-v
) ELSE IF %-arg2%==--v- (
    SET -p=%~1  & CALL :showVersion & SET -help=-v
) ELSE IF %-arg2%==--V- (
    SET -p=%~1  & CALL :showVersion & SET -help=-v
)

CALL %~dp0\slb-return -help -help

ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Shows the documentation
::
:showHelp
    SETLOCAL
    FOR /f "delims=:" %%G IN ('FINDSTR /rbn ":::HELP:::" "%-p%"') DO SET "-s=%%G"
    IF NOT "%-s%"=="" FOR /f "delims=: skip=%-s% tokens=1*" %%G IN ('FINDSTR /n "^" "%-p%"') DO ECHO+%%H
    ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Shows the version
::
:showVersion
    SETLOCAL
    FOR %%G IN (%-p%) DO SET nameAndExt=%%~nxG
    FOR /f "delims=:" %%G IN ('FINDSTR "^::%nameAndExt%" "%-p%"') DO ECHO. & ECHO %%G
    ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Performs batch file analysis discovering and displaying documentation if any.
::
:: slb-helper <FilePath> [-v] [/?]
::   FilePath   File path to parse
::   -v         Shows the batch version
::   /?         Shows this help