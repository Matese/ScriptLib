::slb-git-config Version 0.1
::......................................................................................................................
:: Description:
::   Create git configurations.
::
:: History:
::   - v0.1 2019-12-03 Initial versioned release with embedded documentation
::......................................................................................................................
@ECHO OFF
SETLOCAL

:: default help
CALL slb-helper "%~f0" "%~1" & IF DEFINED -help GOTO :eof

FOR %%I IN ("%~dp0\..") DO SET "-scriptlibgit=%%~fI\libraries\.scriptlib"

:: parse the arguments
CALL slb-argadd %*
IF NOT DEFINED -name SET "-name=not defined"
IF NOT DEFINED -email SET "-email=not defined"

:: default variables
SET -scriptlib=%HOMEDRIVE%%HOMEPATH%\.scriptlib
SET -gitconfig=%HOMEDRIVE%%HOMEPATH%\.gitconfig

:: delete old configurations
RMDIR /S /Q %-scriptlib% 2>nul
DEL %-gitconfig% 2>nul

:: create a new configurations
MKDIR %-scriptlib%
XCOPY /S /Q %-scriptlibgit% %-scriptlib%>nul
TYPE NUL>%-gitconfig%

:: get current encoding and then change it
FOR /f "tokens=2 delims=:." %%x IN ('chcp') DO SET cp=%%x
CHCP 65001 >nul

:: write the content of the file
ECHO [core]>> %-gitconfig%
ECHO 	autocrlf = false>> %-gitconfig%
ECHO 	symlinks = true>> %-gitconfig%
ECHO [user]>> %-gitconfig%
ECHO 	name = %-name%>> %-gitconfig%
ECHO 	email = %-email%>> %-gitconfig%
ECHO [alias]>> %-gitconfig%
ECHO 	super = !$HOMEDRIVE$HOMEPATH/.scriptlib/super.sh>> %-gitconfig%
ECHO 	getter = !$HOMEDRIVE$HOMEPATH/.scriptlib/getter.sh>> %-gitconfig%
ECHO 	lister = !$HOMEDRIVE$HOMEPATH/.scriptlib/lister.sh>> %-gitconfig%
ECHO 	sender = !$HOMEDRIVE$HOMEPATH/.scriptlib/sender.sh>> %-gitconfig%
ECHO 	updater = !$HOMEDRIVE$HOMEPATH/.scriptlib/updater.sh>> %-gitconfig%
ECHO 	checker = !$HOMEDRIVE$HOMEPATH/.scriptlib/checker.sh>> %-gitconfig%
ECHO 	temper = !$HOMEDRIVE$HOMEPATH/.scriptlib/temper.sh>> %-gitconfig%
ECHO 	stater = !$HOMEDRIVE$HOMEPATH/.scriptlib/stater.sh>> %-gitconfig%
ECHO 	wisher = !$HOMEDRIVE$HOMEPATH/.scriptlib/wisher.sh>> %-gitconfig%

:: set old encoding
CHCP %cp%>nul

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Create git configurations.
::
:: slb-git-config <-name:""> <-email:""> [-v] [/?]
::   -name     The name of the user
::   -email    The email of the user
::   -v        Shows the batch version
::   /?        Help
::
:: Sample: 
::    slb-git-config -name:"Juca Pirama" -email:"jucapirama@bixao.com.br"