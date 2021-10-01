::slb-argrem.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Remove (via SET command) args.
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::
:: Remarks:
::   Created to be used in conjunction with slb-argadd
::
::   Sample: slb-argrem -x -a -name -y
::......................................................................................................................

::..................................................................................
:: The main entry point for the script
::
@ECHO OFF
SETLOCAL

:: default help
CALL slb-helper "%~f0" "%~1" & IF DEFINED -help GOTO :eof

:: local variable used to maintain the args temporarily
SET "-vars="

:: get all args and save them into local variable
FOR %%G IN (%*) DO FOR /F "tokens=1,* delims=:" %%H IN ("%%G") DO (
    SET "%%H="
    CALL SET "-vars=%%-vars%%%%H "
)

:: removes the last character from local variable
SET "-vars=%-vars:~0,-1%"

:: remove variables alive after return
CALL slb-return "%-vars%" "%-vars%"

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Remove one or multiple arguments.
::
:: slb-argrem Argument <ArgumentN> [-v] [/?]
::   Argument  The name of the argument
::   -v        Shows the batch version
::   /?        Help