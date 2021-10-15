::slb-rplcer.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Parses a File line by line searching for a replacement.
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::
:: Remarks:
::   Inspired by
::     -> https://stackoverflow.com/questions/11962172/echo-utf-8-characters-in-windows-batch
::     -> https://stackoverflow.com/questions/1427796/batch-file-encoding
::     -> https://stackoverflow.com/questions/1552749/difference-between-cr-lf-lf-and-cr-line-break-types
::     -> https://stackoverflow.com/questions/4527877/batch-script-read-line-by-line
::     -> https://stackoverflow.com/questions/6379619/explain-how-windows-batch-newline-variable-hack-works
::     -> https://stackoverflow.com/questions/6828751/batch-character-escaping
::     -> https://stackoverflow.com/questions/7522740/counting-in-a-for-loop-using-windows-batch-script
::     -> https://stackoverflow.com/questions/9876370/echo-line-to-a-file-on-windows-with-a-unix-linebreak
::     -> https://www.psteiner.com/2012/05/windows-batch-echo-without-new-line.html
::     -> https://www.robvanderwoude.com/ntset.php
::     -> https://www.tutorialspoint.com/batch_script/batch_script_deleting_files.htm
::     -> https://www.tutorialspoint.com/batch_script/batch_script_moving_files.htm
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
IF NOT DEFINED -f ECHO -f is not defined & GOTO :eof
IF "%-f%" EQU "1" ECHO -f is not defined & GOTO :eof
IF NOT DEFINED -o ECHO -o is not defined & GOTO :eof
IF "%-o%" EQU "1" ECHO -o is not defined & GOTO :eof

:: default argument
IF NOT DEFINED -l SET "-l=0"

:: process the file
CALL :processFile "%-f%" "%-l%" "%-o%" "%-n%"

ENDLOCAL & GOTO :eof

::..................................................................................
:: Process the file
::
:processFile
    SETLOCAL

    :: variables
    SET -f=%1
    SET -l=%2
    SET -o=%3
    SET -n=%4
    SET -t="%TEMP%\temp_file.tmp"

    :: delete old temp file
    DEL %-t% 2>nul

    :: create new temp file
    TYPE NUL>%-t%

    :: file line by line loop
    FOR /F "usebackq delims=" %%a in (`"findstr /n ^^ %-f%"`) DO (
        SET "line=%%a"
        call :processLine line %-l% %-t% %-o% %-n%
    )

    :: delete current file
    DEL %-f%

    :: move new file
    MOVE /Y %-t% %-f%

    ENDLOCAL & GOTO :eof

::..................................................................................
:: Process the line
::
:processLine
    SETLOCAL

    :: variables
    SETLOCAL EnableDelayedExpansion
    SET "line=!%1!"
    SET "line=!line:*:=!"
    SETLOCAL DisableDelayedExpansion
    SET -l=%2
    SET -t=%3
    set -t=%-t:"=%
    SET -o=%4
    SET -o=%-o:"=%
    SET -n=%5
    IF DEFINED -n SET -n=%-n:"=%

    :: get current encoding and then change it to UTF8
    FOR /f "tokens=2 delims=:." %%x IN ('chcp') DO SET cp=%%x
    CHCP 65001 >nul

    SETLOCAL EnableDelayedExpansion

:: newline hack
(SET LF=^
%=EMPTY=%
)

    :: if line is found
    IF "%line%"=="%-o%" (
        IF NOT "%-n%"=="" (
            IF "%-l%"=="0" (
                ECHO %-n%>> %-t%
            ) ELSE (
                <nul set /p=%-n%!LF!>> %-t%
            )
        )
    ) ELSE (
        IF "%line%"=="" (
            ECHO.>> %-t%
        ) ELSE (
            IF "%-l%"=="0" (
                ECHO %line%>> %-t%
            ) ELSE (
                <nul set /p=%line%!LF!>> %-t%
            )
        )
    )

    SETLOCAL DisableDelayedExpansion

    :: set old encoding
    CHCP %cp% >nul

    ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Parses a File line by line searching for a replacement.
::
::   slb-rplcer <-f:> <-o:> <-n:> [-l] [-v] [/?]
::   -f:       The name of the file to be searched
::   -o:       The content of the old line
::   -n:       The content of the new line
::   -l        Line Feed (Linux, MAC OSX)
::   -v        Shows the batch version
::   /?        Shows this help