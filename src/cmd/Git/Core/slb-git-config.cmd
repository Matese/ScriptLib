::slb-git-config.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Create git configurations.
::
:: History:
::   - v0.1 2021-09-21 Initial versioned release with embedded documentation
::
:: Remarks:
::   Inspired by
::     -> http://tdongsi.github.io/blog/2016/02/20/symlinks-in-git/
::     -> https://stackoverflow.com/questions/11962172/echo-utf-8-characters-in-windows-batch
::     -> https://stackoverflow.com/questions/1427796/batch-file-encoding
::     -> https://stackoverflow.com/questions/61008701/batch-script-convert-path-to-linux-format-using-wslpath
::     -> https://stackoverflow.com/questions/6379619/explain-how-windows-batch-newline-variable-hack-works
::     -> https://stackoverflow.com/questions/6828751/batch-character-escaping
::     -> https://stackoverflow.com/questions/9876370/echo-line-to-a-file-on-windows-with-a-unix-linebreak
::......................................................................................................................
@ECHO OFF
SETLOCAL

:: default help
CALL slb-helper "%~f0" "%~1" & IF DEFINED -help GOTO :eof

:: needs to go first (otherwise it can override arguments)
CALL :installDependencies

:: parse the arguments
CALL slb-argadd %*

:: script slb-git-config.sh
SET -script=-sh:"%~dp0%0.sh"
SET -script=%-script:src\cmd=src\sh%

:: Get a configuration
IF DEFINED -g (
    CALL slb-wrappr %-script% '%*'
    GOTO :eof
)

:: Delete a configuration
IF DEFINED -d (
    CALL slb-wrappr %-script% '%*'
    GOTO :eof
)

:: Set a configuration
IF DEFINED -sk (
    CALL slb-wrappr %-script% '%*'
    GOTO :eof
)

:: check for empty arguments
IF NOT DEFINED -n ECHO -n is not defined & GOTO :eof
IF "%-n%" EQU "1" ECHO -n is not defined & GOTO :eof
IF NOT DEFINED -e ECHO -e is not defined & GOTO :eof
IF "%-e%" EQU "1" ECHO -e is not defined & GOTO :eof

:: upsurl
IF DEFINED -u (
    CALL slb-wrappr %-script% '-sk:"upsurl" -sv:"%-u%"' >NUL
)

:: upsgid
if DEFINED -i (
    CALL slb-wrappr %-script% '-sk:"upsgid" -sv:"%-i%"' >NUL
)

:: upsapi
if DEFINED -t (
    CALL slb-wrappr %-script% '-sk:"upsapi" -sv:"%-t%"' >NUL
)

:: script dir as linux
SET "-path=%~p0"
SET "-drive=%~d0"
SET "-scriptdir=/%-drive:~0,1%%-path:\=/%"
SET -scriptdir=%-scriptdir:/ScriptLib/src/cmd/=/ScriptLib/src/sh/%
CALL :gitConfig %-scriptdir%

ECHO Configuration created!

ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Create Git configuration
::
:gitConfig
    SETLOCAL

    SET -scriptdir=%1

    :: create .gitconfig file name
    SET -gitconfig=%HOMEDRIVE%%HOMEPATH%\.gitconfig

    :: delete old .gitconfig file
    DEL %-gitconfig% 2>nul

    :: create new .gitconfig file
    TYPE NUL>%-gitconfig%

    :: get current encoding and then change it to UTF8
    FOR /f "tokens=2 delims=:." %%x IN ('chcp') DO SET cp=%%x
    CHCP 65001 >nul

    SETLOCAL EnableDelayedExpansion

:: newline hack
(SET LF=^
%=EMPTY=%
)

    :: create content variable
    SET -content=!-content![core]!LF!>> !-gitconfig!
    SET -content=!-content!	symlinks = true!LF!>> !-gitconfig!
    SET -content=!-content![user]!LF!>> !-gitconfig!
    SET -content=!-content!	name = !-n!!LF!>> !-gitconfig!
    SET -content=!-content!	email = !-e!!LF!>> !-gitconfig!
    SET -content=!-content![alias]!LF!>> !-gitconfig!
    SET -content=!-content!	puller = ^^!bash !-scriptdir!slb-git-puller.sh!LF!>> !-gitconfig!
    SET -content=!-content!	getter = ^^!bash !-scriptdir!slb-git-getter.sh!LF!>> !-gitconfig!
    SET -content=!-content!	lister = ^^!bash !-scriptdir!slb-git-lister.sh!LF!>> !-gitconfig!
    SET -content=!-content!	sender = ^^!bash !-scriptdir!slb-git-sender.sh!LF!>> !-gitconfig!
    SET -content=!-content!	updter = ^^!bash !-scriptdir!slb-git-updter.sh!LF!>> !-gitconfig!
    SET -content=!-content!	checkr = ^^!bash !-scriptdir!slb-git-checkr.sh!LF!>> !-gitconfig!
    SET -content=!-content!	stater = ^^!bash !-scriptdir!slb-git-stater.sh!LF!>> !-gitconfig!
    SET -content=!-content!	guider = ^^!bash !-scriptdir!slb-git-guider.sh!LF!>> !-gitconfig!

    :: write content variable to .gitconfig file
    ECHO !-content!>> !-gitconfig!

    SETLOCAL DisableDelayedExpansion

    :: set old encoding
    CHCP %cp% >nul

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
:: Create git configurations.
::
:: slb-git-config <-n:> <-e:> [u:] [i:] [t:] [-g:] [-d:] [-sk:-sv:] [-v] [/?]
::   -n:       The name of the user
::   -e:       The email of the user
::   -u        Upstream URL
::   -i        Upstream Group ID
::   -t        Upstream API Authorization Token
::   -g:       Get a configuration
::   -d:       Delete a configuration
::   -sk:      Set configuration key
::   -sv:      Set configuration value
::   -v        Shows the script version
::   /?        Shows this help
::
:: Sample:
::    slb-git-config -n:"Juca Pirama" -e:jucapirama@bixao.com.br -u:https://gitlab.com/xxx -i:xxx -t:xxx
::    slb-git-config -n:"Juca Pirama" -e:jucapirama@bixao.com.br -u:"C:/Users/Bixao/Repos"