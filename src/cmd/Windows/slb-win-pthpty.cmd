::slb-win-pthpty.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Pretty print windows environment variables (USER or SYSTEM)
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::
:: Remarks:
::   Inspired by
::     -> https://stackoverflow.com/questions/5471556/pretty-print-windows-path-variable-how-to-split-on-in-cmd-shell
::     -> https://stackoverflow.com/questions/19581078/when-querying-the-registry-from-a-batch-file-can-i-query-the-data
::......................................................................................................................
@ECHO OFF
SETLOCAL

:: default help
CALL slb-helper "%~f0" "%~1" & IF DEFINED -help GOTO :eof

:: parse the arguments
CALL slb-argadd %*

:: check for empty argument
IF NOT DEFINED -opt ECHO -opt is not defined & GOTO :eof

:: check for valid argument (accepts USER or SYSTEM)
IF NOT "%-opt%" EQU "USER" IF NOT "%-opt%" EQU "SYSTEM" ECHO. & ECHO invalid option, needs to be USER or SYSTEM & ENDLOCAL & GOTO :eof

:: set the -query (will be USER or SYSTEM)
IF "%-opt%" EQU "USER" SET -query="HKCU\Environment"
IF "%-opt%" EQU "SYSTEM" SET -query="HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"

:: set -path variable with reg query, "skip=2 tokens=2*" will skip "path" and "REG_EXPAND_SZ"
FOR /F "skip=2 tokens=2*" %%a IN ('reg query %-query% /v path') DO (SET -path="%%b")

:: preety print
CALL :prettyPrint

ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Pretty print -path variable
::
:prettyPrint
    :: remove double quotes
    SET -path=%-path:"=%

    :: semicolons inside of quotes should be ignored
    SETLOCAL DisableDelayedExpansion
    SET "-path=%-path:"=""%"
    SET "-path=%-path:^=^^%"
    SET "-path=%-path:&=^&%"
    SET "-path=%-path:|=^|%"
    SET "-path=%-path:<=^<%"
    SET "-path=%-path:>=^>%"
    SET "-path=%-path:;=^;^;%"
    SET -path=%-path:""="%
    SET "-path=%-path:"=""Q%"
    SET "-path=%-path:;;="S"S%"
    SET "-path=%-path:^;^;=;%"
    SET "-path=%-path:""="%"
    SETLOCAL EnableDelayedExpansion
    SET "-path=!-path:"Q=!"

    :: only the normal semicolons should be replaced with ";"
    FOR %%a IN ("!-path:"S"S=";"!") DO (
        if "!!"=="" endlocal
        if %%a neq "" echo %%~a
    )

    GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Pretty print windows environment variables (USER or SYSTEM)
::
:: slb-win-pthpty <-opt> [-v] [/?]
::   -opt      USER or SYSTEM
::   -v        Shows the batch version
::   /?        Help
::
:: Sample:
::    slb-win-pthpty -opt USER