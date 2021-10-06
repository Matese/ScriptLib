::..................................................................................
:: Description:
::   Create symlink
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::
:: Remarks:
::   Inspired by
::     -> https://stackoverflow.com/questions/18654162/enable-native-ntfs-symbolic-links-for-cygwin
::..................................................................................

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
IF NOT DEFINED -l ECHO -l is not defined & GOTO :eof
IF "%-l%" EQU "1" ECHO -l is not defined & GOTO :eof
IF NOT DEFINED -t ECHO -t is not defined & GOTO :eof
IF "%-t%" EQU "1" ECHO -t is not defined & GOTO :eof

:: file
IF DEFINED -f (
    CALL :symlinkFile "%-l%" "%-t%"
)

:: directory
IF DEFINED -d (
    CALL :symlinkDirectory "%-l%" "%-t%"
)

ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Create File Symbolic Link
::
:symlinkFile
    SETLOCAL
    MKLINK %1 %2
    ENDLOCAL & GOTO :eof

::......................................................................................................................
::  Create Directory Symbolic Link
::
:symlinkDirectory
    SETLOCAL
    MKLINK "/D" %1 %2
    ENDLOCAL & GOTO :eof

::..................................................................................
:::HELP:::
::
:: Create symlink
::
:: slb-symlnk.sh [-d] [-f] <-l:> <-t:> [-v] [/?]
::   -d         Directory Symbolic Link
::   -f         File Symbolic Link
::   -l:        Link path
::   -t:        Target path
::   -v         Shows the script version
::   /?         Shows this help