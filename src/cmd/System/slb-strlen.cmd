::slb-strlen.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Get the length of a String.
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::
:: Remarks:
::   Inspired by
::     -> https://ss64.com/nt/syntax-strlen.html
::......................................................................................................................

::..................................................................................
:: The main entry point for the script
::
@ECHO OFF
SETLOCAL

:: default help
CALL slb-helper "%~f0" "%~1" & IF DEFINED -help GOTO :eof

:: parse the arguments
CALL slb-argadd %*

:: check for empty arguments
IF NOT DEFINED -str ECHO -str is not defined & GOTO :eof
IF "%-str%" EQU "1" ECHO -str is not defined & GOTO :eof

:: calculate and print the string length
CALL :strlen -str -length
ECHO %-length%

:: return -strlen param
CALL slb-return -length -strlen
ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Return the length of a string
::
:strlen StrVar [RtnVar]
    SETLOCAL EnableDelayedExpansion
    SET "s=#!%~1!"
    SET "len=0"
    for %%N in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
      if "!s:~%%N,1!" neq "" (
        SET /a "len+=%%N"
        SET "s=!s:~%%N!"
      )
    )
    ENDLOCAL & if "%~2" neq "" (set %~2=%len%) else ECHO %len%
    GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: This function can be used to return the length of a string.
::
:: slb-strlen <-str:> [-v] [/?]
::   -str:     The string to calculate the length
::   -v        Shows the batch version
::   /?        Help
::
:: Sample:
::    slb-strlen -str:"Juca Pirama"