::slb-git-config.cmd Version 0.1
::......................................................................................................................
:: Description:
::   Create git configurations.
::
:: History:
::   - v0.1 2019-12-03 Initial versioned release with embedded documentation
::
:: Remarks:
::   Inspired by
::     -> https://stackoverflow.com/questions/9876370/echo-line-to-a-file-on-windows-with-a-unix-linebreak
::     -> https://stackoverflow.com/questions/6379619/explain-how-windows-batch-newline-variable-hack-works
::     -> https://stackoverflow.com/questions/11962172/echo-utf-8-characters-in-windows-batch
::     -> https://stackoverflow.com/questions/1427796/batch-file-encoding
::     -> https://stackoverflow.com/questions/6828751/batch-character-escaping
::     -> http://tdongsi.github.io/blog/2016/02/20/symlinks-in-git/
::......................................................................................................................
@ECHO OFF
SETLOCAL

:: default help
CALL slb-helper "%~f0" "%~1" & IF DEFINED -help GOTO :eof

:: parse the arguments
CALL slb-argadd %*

:: check for empty arguments
IF NOT DEFINED -name ECHO -name is not defined & GOTO :eof
IF NOT DEFINED -email ECHO -email is not defined & GOTO :eof

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
set -content=!-content![core]!LF!>> !-gitconfig!
set -content=!-content!	symlinks = true!LF!>> !-gitconfig!
set -content=!-content![user]!LF!>> !-gitconfig!
set -content=!-content!	name = !-name!!LF!>> !-gitconfig!
set -content=!-content!	email = !-email!!LF!>> !-gitconfig!
set -content=!-content![alias]!LF!>> !-gitconfig!
set -content=!-content!	super = ^^!$ScriptLib/src/sh/Git/slb-git-super.sh!LF!>> !-gitconfig!
set -content=!-content!	getter = ^^!$ScriptLib/src/sh/Git/slb-git-getter.sh!LF!>> !-gitconfig!
set -content=!-content!	lister = ^^!$ScriptLib/src/sh/Git/slb-git-lister.sh!LF!>> !-gitconfig!
set -content=!-content!	sender = ^^!$ScriptLib/src/sh/Git/slb-git-sender.sh!LF!>> !-gitconfig!
set -content=!-content!	updater = ^^!$ScriptLib/src/sh/Git/slb-git-updter.sh!LF!>> !-gitconfig!
set -content=!-content!	checker = ^^!$ScriptLib/src/sh/Git/slb-git-checkr.sh!LF!>> !-gitconfig!
set -content=!-content!	temper = ^^!$ScriptLib/src/sh/Git/slb-git-temper.sh!LF!>> !-gitconfig!
set -content=!-content!	stater = ^^!$ScriptLib/src/sh/Git/slb-git-stater.sh!LF!>> !-gitconfig!
set -content=!-content!	wisher = ^^!$ScriptLib/src/sh/Git/slb-git-wisher.sh!LF!>> !-gitconfig!

:: write content variable to .gitconfig file
ECHO !-content!>> !-gitconfig!

SETLOCAL DisableDelayedExpansion

:: set old encoding
CHCP %cp% >nul

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Create git configurations.
::
:: slb-git-config <-name> <-email> [-v] [/?]
::   -name     The name of the user
::   -email    The email of the user
::   -v        Shows the batch version
::   /?        Help
::
:: Sample:
::    slb-git-config -name:"Juca Pirama" -email:"jucapirama@bixao.com.br"