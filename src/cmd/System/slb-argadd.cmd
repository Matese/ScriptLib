::slb-argadd.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Parse and define (via SET command) args to be used.
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::
:: Remarks:
::   Args should:
::     - Be defined along with default values, using a <space> delimiter between options
::     - Have the format <arg>[:<value>]
::   Args are:
::     - NOT case sensitive.
::   Args can:
::    - Have a default value, wich is used if the option is not provided
::
::   If the default value contains spaces, special characters, or starts with a colon,
::   then it should be enclosed within double quotes. The default can be undefined by
::   specifying the default as empty quotes "".
::   NOTE - defaults cannot contain * or ? with this solution.
::
::   Args that are specified without any default value are simply flags that are either
::   defined or undefined. All flags start out undefined by default and become defined if
::   the option is supplied. The order of the definitions is not important.
::
::   Sample: slb-argadd -x -a:foo -name:"juca pirama" -y
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
    SET "%%H=%%~I" & IF -%%~I-==-- SET "%%H=1"
    CALL SET "-vars=%%-vars%%%%H "
)

:: removes the last character from local variable
SET "-vars=%-vars:~0,-1%"

:: keep variables alive after return
CALL slb-return "%-vars%" "%-vars%"

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Parse and define one or multiple arguments, containing value or not.
::
:: slb-argadd Argument<:Value> <<ArgumentN>:<ValueN>> [-v] [/?]
::   Argument  The name of the argument
::   Value     The value of the argument (if nothing defined, defaults to 1)
::   -v        Shows the batch version
::   /?        Help