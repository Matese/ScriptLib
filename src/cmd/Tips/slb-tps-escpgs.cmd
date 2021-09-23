::slb-tps-escpgs.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Batch script escaping patterns.
::
:: History:
::   - v0.1 2019-12-03 Initial versioned release with embedded documentation
::
:: Remarks:
::   Inspired by
::     -> https://stackoverflow.com/questions/28697619/using-quotes-and-other-special-characters-on-cmd-command-line
::......................................................................................................................
@ECHO OFF
SETLOCAL

:: default help
CALL slb-helper "%~f0" "%~1" & IF DEFINED -help GOTO :eof

:: print escaping patterns
ECHO ^@  - At Symbol: be less verbose
ECHO ^~  - Tilde: Parameter Expansion as in Call subroutines, FOR loops etc.
ECHO ^&  - Single Ampersand: used as a command separator
ECHO ^&^& - Double Ampersand: conditional command separator (if errorlevel 0)
ECHO ^|^| - Double Pipe: conditional command separator (if errorlevel ^> 0)
ECHO ^:^: - Double Colon: alternative to "rem" for comments outside of code blocks
ECHO ^^  - Caret: general escape character in batch
ECHO ^"  - Double Quote: surrounding a string in double quotes 
ECHO      escapes all of the characters contained within it
ECHO ^() - Parentheses: used to make "code blocks" of grouped commands
ECHO %%  - Percentage Sign: are used to mark three of the four variable types
@setlocal enabledelayedexpansion
ECHO ^^!  - Exclamation Mark: to mark delayed expansion environment variables ^^!var^^!
@endlocal
@setlocal disabledelayedexpansion
ECHO ^!  - Exclamation Mark: to mark delayed expansion environment variables ^!var^!
@endlocal
ECHO ^*  - Asterisk: wildcard matches any number or any characters
ECHO ^?  - Question Mark: matches any single character
ECHO ^.  - Single dot: represents the current directory
ECHO ^.. - Double dot: represents the parent directory of the current directory
ECHO ^\  - Backslash: represent the root directory of a drive dir ^\
ECHO ^|  - Single Pipe: redirects the std.output of one command
ECHO      into the std.input of another
ECHO ^NUL (File like device): is like a bottomless pit
ECHO ^CON (File like device): is a file like device that represents the console
ECHO ^>  - Single Greater Than: redirects output to either a file or file like device
ECHO ^>^> - Double Greater than: output will be added to the very end of the file
ECHO ^<  - Less Than: redirect the contents of a file to the std.input of a command
ECHO      Stream redirection: regarding the less and greater than symbols
ECHO      "http://judago.webs.com/batchoperators.htm"

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Some tips and tricks related to escaping patterns in batch programming.
::
:: slb-tps-escpgs [-v] [/?]
::   -v        Shows the batch version
::   /?        Help