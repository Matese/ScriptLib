::slb-win-pthcur.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Get windows environment variables (USER or SYSTEM)
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

:: remove double quotes
SET -path=%-path:"=%

ECHO.
ECHO %-path%

:: return -path param
CALL slb-return -path -path
ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Get windows environment variables (USER or SYSTEM)
::
:: slb-win-pthcur <-opt> [-v] [/?]
::   -opt      USER or SYSTEM
::   -v        Shows the batch version
::   /?        Help
::
:: Sample:
::    slb-win-pthcur