::slb-git-depend.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Instal dependencies.
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::......................................................................................................................
@ECHO OFF
SETLOCAL

:: default help
CALL slb-helper "%~f0" "%~1" & IF DEFINED -help GOTO :eof

:: install dependencies
CALL :installDependencies

ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Install dependencies
::
:installDependencies
    SETLOCAL
    ECHO.
    CALL slb slperm
    ECHO.
    CALL slb ichoco -i
    ECHO.
    CALL C:\ProgramData\chocolatey\choco install jq
    ECHO.
    ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Instal dependencies.
::
:: slb-git-depend [-v] [/?]