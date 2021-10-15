::slb.cmd Version 0.1
::......................................................................................................................
:: Description:
::   ScriptLib command invoker
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::
:: Remarks:
::   Inspired by
::     -> https://stackoverflow.com/questions/935609/batch-parameters-everything-after-1
::......................................................................................................................

::..................................................................................
:: The main entry point for the script
::
@ECHO OFF
SETLOCAL

:: default help
CALL slb-helper "%~f0" "%~1" & IF DEFINED -help GOTO :eof

SETLOCAL EnableDelayedExpansion
SET tempvar=%2

:: if passing /? or --help as first argument, use double quotes
:: to bypass CALL help and invoke the script
IF "!tempvar!"=="/?" CALL slb-%~1 "/?" & GOTO :eof
IF "!tempvar!"=="--help" CALL slb-%~1 "/?" & GOTO :eof

SETLOCAL DisableDelayedExpansion

:: get all arguments but first and invoke the script
SET _tail=%*
IF NOT "%~1"=="" CALL SET _tail=%%_tail:*%1=%%
IF NOT "%~1"=="" CALL slb-%~1%_tail%

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: ScriptLib command invoker
::
:: slb [command] [-v] [/?]
::   argadd      Parse and define args.
::   argrem      Remove args.
::   helper      Performs file documentation analysis.
::   output      Capture command outputs, a bit like the behaviour of the bash shell.
::   pthcur      Get windows environment variables (USER or SYSTEM)
::   pthpty      Pretty print windows environment variables (USER or SYSTEM)
::   pthrem      Remove the entry from PATH that ends with input string.
::   pthsch      Search everything in PATH for the first occurance of a file.
::   return      Simulates the return concept of a function.
::   scfdng      TODO
::   strlen      Get the length of a String.
::   symlnk      Create NTFS (Windows) links that is usable by Windows and Cygwin.
::   wrappr      A wrapper used to call shell scripts from batch.
::   git-ckeckr  TODO
::   git-config  Create git configurations.
::   git-getter  TODO
::   git-guider  TODO
::   git-lister  TODO
::   git-puller  TODO
::   git-sender  TODO
::   git-stater  TODO
::   git-updter  TODO
::   net-shdlib  TODO
::   win-svcmgr  Communicates with Service Control Manager interacting with services.
::   -v          Shows the batch version
::   /?          Help