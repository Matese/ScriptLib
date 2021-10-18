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

:: parse the arguments
CALL slb-argadd %*

:: install dependencies
CALL :installDependencies

:: Get a configuration
IF DEFINED -g (
    CALL :getConfig %~f0 %~1 %~dp0%0.sh %*
    GOTO :eof
)

:: Delete a configuration
IF DEFINED -d (
    CALL :delConfig %~f0 %~1 %~dp0%0.sh %*
    GOTO :eof
)

:: Set a configuration
IF DEFINED -sk (
    CALL :setConfig %~f0 %~1 %~dp0%0.sh %*
    GOTO :eof
)

:: check for empty arguments
IF NOT DEFINED -n ECHO -n is not defined & GOTO :eof
IF "%-n%" EQU "1" ECHO -n is not defined & GOTO :eof
IF NOT DEFINED -e ECHO -e is not defined & GOTO :eof
IF "%-e%" EQU "1" ECHO -e is not defined & GOTO :eof

:: get this script path
SET "-path=%~p0"
SET "-drive=%~d0"
SET "-scriptdir=/%-drive:~0,1%%-path:\=/%"
SET -scriptdir=%-scriptdir:/ScriptLib/src/cmd/=/ScriptLib/src/sh/%
CALL :gitConfig %-scriptdir%

ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Get configuration
::
:getConfig
    SETLOCAL

    :: boilerplate
    CALL slb-helper "%1" "%2" >NUL
    IF DEFINED -help SET -args=-arg:%-help%
    IF NOT DEFINED -help SET -args='%4'
    SET -script=-sh:"%3"
    CALL slb-wrappr %-script% %-args%

    ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Set configuration
::
:setConfig
    SETLOCAL

    :: boilerplate
    CALL slb-helper "%1" "%2" >NUL
    IF DEFINED -help SET -args=-arg:%-help%
    IF NOT DEFINED -help SET -args='%4'
    SET -script=-sh:"%3"
    CALL slb-wrappr %-script% %-args%

    ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Delete configuration
::
:delConfig
    SETLOCAL

    :: boilerplate
    CALL slb-helper "%1" "%2" >NUL
    IF DEFINED -help SET -args=-arg:%-help%
    IF NOT DEFINED -help SET -args='%4'
    SET -script=-sh:"%3"
    CALL slb-wrappr %-script% %-args%

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

    CALL slb slperm
    CALL slb ichoco -i
    CALL choco install jq

    ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Create git configurations.
::
:: slb-git-config <-n:> <-e:> [-g:] [-d:] [-sk:-sv:] [-v] [/?]
::   -n:       The name of the user
::   -e:       The email of the user
::   -g:       Get a configuration
::   -d:       Delete a configuration
::   -sk:      Set configuration key
::   -sv:      Set configuration value
::   -v        Shows the script version
::   /?        Shows this help
::
:: Possible configurations are:
::   gsups      Git Scaffolding Upstream
::
:: Sample:
::    slb-git-config -n:"Juca Pirama" -e:jucapirama@bixao.com.br
::    slb-git-config -sk:gsups -sv:"C:/Users/Bixao/Repos"