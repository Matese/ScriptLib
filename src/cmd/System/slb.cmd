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

:: parse command
SET _cmd=%~1
IF "%_cmd%"=="config" SET _cmd=slb-git-config
IF "%_cmd%"=="getter" SET _cmd=slb-git-getter
IF "%_cmd%"=="lister" SET _cmd=slb-git-lister
IF "%_cmd%"=="puller" SET _cmd=slb-git-puller
IF "%_cmd%"=="scfdng" SET _cmd=slb-git-scfdng
IF "%_cmd%"=="sender" SET _cmd=slb-git-sender
IF "%_cmd%"=="stater" SET _cmd=slb-git-stater
IF "%_cmd%"=="ichoco" SET _cmd=slb-win-ichoco
IF "%_cmd%"=="igpedt" SET _cmd=slb-win-igpedt
IF "%_cmd%"=="slperm" SET _cmd=slb-win-slperm
IF "%_cmd%"=="svcmgr" SET _cmd=slb-win-svcmgr
IF "%_cmd%"=="pthpty" SET _cmd=slb-pthpty
IF "%_cmd%"=="pthrem" SET _cmd=slb-pthrem
IF "%_cmd%"=="pthsch" SET _cmd=slb-pthsch
IF "%_cmd%"=="strlen" SET _cmd=slb-strlen
IF "%_cmd%"=="symlnk" SET _cmd=slb-symlnk

:: default help
CALL slb-helper "%~f0" "%_cmd%" & IF DEFINED -help GOTO :eof

:: if passing /?,--help,-v ou--version as first argument,
:: use double quotes to bypass CALL help and invoke the script
SETLOCAL EnableDelayedExpansion
SET _arg=%2
IF "!_arg!"=="/?" CALL %_cmd% "/?" & GOTO :eof
IF "!_arg!"=="--help" CALL %_cmd% "/?" & GOTO :eof
IF "!_arg!"=="-v" CALL %_cmd% "-v" & GOTO :eof
IF "!_arg!"=="--version" CALL %_cmd% "-v" & GOTO :eof
SETLOCAL DisableDelayedExpansion

:: parse tail arguments and call script
SET _tail=%*
IF NOT "%~1"=="" CALL SET _tail=%%_tail:*%~1=%%
IF NOT "%_cmd%"=="" CALL %_cmd%%_tail%

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: ScriptLib command invoker
::
:: slb [command] [-v] [/?]
::
::  (Git)
::   config      Create git configurations
::   getter      Clone projects and modules
::   lister      List projects and modules
::   puller      Pull projects and modules
::   scfdng      Scaffold projects and modules
::   sender      Save projects and modules
::   stater      Check for status changes
::   updter      Update projects and modules
::
::  (Windows)
::   ichoco      Chocolatey package manager installer
::   igpedt      Group policy editor installer
::   slperm      Add Symlink permissions to Local Security Policy
::   svcmgr      Communicates with Service Control Manager interacting with services
::
::  (System)
::   pthpty      Pretty print windows environment variables (USER or SYSTEM)
::   pthrem      Remove the entry from PATH that ends with input string
::   pthsch      Search everything in PATH for the first occurance of a file
::   strlen      Get the length of a String
::   symlnk      Create NTFS (Windows) links that is usable by Windows and Cygwin
::   -v          Shows the batch version
::   /?          Help