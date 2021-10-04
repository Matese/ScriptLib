::slb-pthrem.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Remove the entry from PATH that ends with input string.
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::
:: Remarks:
::   Inspired by
::     -> https://stackoverflow.com/questions/5471556/pretty-print-windows-path-variable-how-to-split-on-in-cmd-shell
::     -> https://stackoverflow.com/questions/21765687/remove-quotes-from-string-in-batch-file
::     -> https://stackoverflow.com/questions/49651545/use-an-environment-variable-in-a-windows-cmd-file-as-substring-length-parameter
::     -> http://scripts.dragon-it.co.uk/scripts.nsf/docs/batch-search-replace-substitute
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
IF NOT DEFINED -opt ECHO -opt is not defined & GOTO :eof
IF NOT DEFINED -str ECHO -str is not defined & GOTO :eof
IF "%-opt%" EQU "1" ECHO -opt is not defined & GOTO :eof
IF "%-str%" EQU "1" ECHO -str is not defined & GOTO :eof

:: replace + by %
IF DEFINED -r (
  SETLOCAL EnableDelayedExpansion
  set temp=!-str!
  set temp=!temp:+=%%!
  set -str=!temp!
  SETLOCAL DisableDelayedExpansion
)

:: check for valid argument (accepts USER or SYSTEM)
IF NOT "%-opt%" EQU "USER" IF NOT "%-opt%" EQU "SYSTEM" ECHO. & ECHO invalid option, needs to be USER or SYSTEM & ENDLOCAL & GOTO :eof

:: below >NUL statement will hide output of if command executes successfully
CALL slb-strlen -str:"%-str%" >NUL

:: set the -query (will be USER or SYSTEM)
IF "%-opt%" EQU "USER" SET -query="HKCU\Environment"
IF "%-opt%" EQU "SYSTEM" SET -query="HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"

:: set -path variable with reg query, "skip=2 tokens=2*" will skip "path" and "REG_EXPAND_SZ"
FOR /F "skip=2 tokens=2*" %%a IN ('reg query %-query% /v path') DO (SET -path=%%b)

:: semicolons inside of quotes should be ignored, only the normal semicolons should be replaced with ";"
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
SET "-entry="
SET "-newPath="
FOR %%a IN ("!-path:"S"S=";"!") DO (
    IF %%a neq "" (
      :: set -endsWith with last x characters from -entry
      SET -entry=%%~a
      SET -endsWith=!-entry:~-%-strlen%!
      :: if not found, append -entry to -newPath
      IF /i NOT ["%-str%"]==["!-endsWith!"] (
        SET -newPath=!-newPath!!-entry!;
      )
    )
)

:: argument to be used in SETX command
IF "%-opt%" EQU "USER" SET "-a="
IF "%-opt%" EQU "SYSTEM" SET "-a=/m"

:: set new environment variables
SETX %-a% PATH "%-newPath%" >NUL

ECHO %-newPath%

:: return -path param
CALL slb-return -newPath -path
ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Remove the entry from PATH that ends with input string.
::
:: slb-pthrem <-opt:> <-str:> [-r] [-v] [/?]
::   -opt:     USER or SYSTEM
::   -str:     The ends with string
::   -r        Should replace + by %
::   -v        Shows the batch version
::   /?        Help
::
:: Sample:
::   slb-pthrem -opt:USER -str:"Juca Pirama"