::slb-wrappr.cmd Version 0.1
::......................................................................................................................
:: Description:
::   A wrapper used to call shell scripts from batch.
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::
:: Remarks:
::   Inspired by
::     -> https://blog.dotsmart.net/2011/01/27/executing-cygwin-bash-scripts-on-windows/
::     -> https://stackoverflow.com/questions/26522789/how-to-run-sh-on-windows-command-prompt
::     -> https://superuser.com/questions/1104567/how-can-i-find-out-the-command-line-options-for-git-bash-exe
::     -> https://stackoverflow.com/questions/1964192/removing-double-quotes-from-variables-in-batch-file-creates-problems-with-cmd-en
::     -> https://stackoverflow.com/questions/9594066/how-to-get-program-files-x86-env-variable
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

:: check for empty argument
IF NOT DEFINED -sh ECHO -sh is not defined & GOTO :eof
IF "%-sh%" EQU "1" ECHO -sh is not defined & GOTO :eof

:: replace 'cmd' path to 'sh' path
SETLOCAL EnableDelayedExpansion
FOR /F "delims=" %%A in ("%~dp0..\..\..\") do set "basedir=%%~fA"
set -from=%basedir%src\cmd
set -to=%basedir%src\sh
CALL SET "-sh=%%-sh:!-from!=!-to!%%"
SETLOCAL DisableDelayedExpansion

:: check for valid argument
IF NOT EXIST "%-sh%" ECHO Script "%-sh%" not found & ENDLOCAL & GOTO :eof

:: check if git exists
SET -gitdir="%ProgramFiles%\Git\"
SET -gitdir=%-gitdir:"=%
IF NOT EXIST "%-gitdir%" ECHO Couldn't find git at "%-gitdir%" & GOTO :eof

:: check if cygpath exists
SET -cygpath="%-gitdir%usr\bin\cygpath.exe"
SET -cygpath=%-cygpath:"=%
IF NOT EXIST "%-cygpath%" ECHO Couldn't find cygpath at "%-cygpath%" & GOTO :eof

:: check if bash exists
SET -bash="%-gitdir%bin\bash.exe"
SET -bash=%-bash:"=%
IF NOT EXIST "%-bash%" echo Couldn't find bash at "%-bash%" & GOTO :eof

:: Resolve shell script based *nix path
FOR /f "delims=" %%A IN ('CALL "%-cygpath%" "%-sh%"') DO SET -script=%%A

:: Cleanup <-sh:> arg from the rest of the args
SET -args=%* & CALL SET -args=%%-args:-sh:"%-sh%" =%% & CALL SET -args=%%-args:-arg:=%%

:: Invoke the script passing parsed arguments
::ENDLOCAL & "%-bash%" --login "%-script%" %-args%
ENDLOCAL & "C:\Program Files\Git\usr\bin\bash.exe" --login "%-script%" %-args%

::......................................................................................................................
:::HELP:::
::
:: A wrapper used to call shell scripts from batch.
::
:: slb-wrappr <-sh:> [arg:] [-v] [/?]
::   -sh:      The shell script path
::   -arg:     The shell script argument (can have multiple)
::   -v        Shows the batch version
::   /?        Help
::
:: Sample:
::   slb-wrappr -sh:c:\foo.sh -arg:first -arg:"second argument"