#!/bin/bash
#slb-git-guider.sh Version 0.1
#..................................................................................
# Description:
#   Wish git-gui if status has changes.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://how.wtf/ternary-operator-in-bash.html
#     -> https://stackoverflow.com/questions/16905183/dash-double-semicolon-syntax
#     -> https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
#     -> https://stackoverflow.com/questions/8352851/how-to-call-one-shell-script-from-another-shell-script
#     -> https://stackoverflow.com/questions/31128783/how-to-find-the-install-path-of-git-in-mac-or-linux
#     -> https://askubuntu.com/questions/408784/after-doing-a-sudo-apt-get-install-app-where-does-the-application-get-stored
#     -> https://stackoverflow.com/questions/18937393/list-of-executables-installed-from-package
#     -> https://stackoverflow.com/questions/21231359/running-executable-files-in-linux
#     -> https://stackoverflow.com/questions/59002095/when-i-run-the-git-gui-in-git-bash-on-windows-10-i-get-line-3-exec-wish-not
#     -> https://stackoverflow.com/questions/53563543/bash-shell-access-to-programfilesx86-environment-variable
#     -> https://tecadmin.net/bash-remove-double-quote-string/
#     -> https://stackoverflow.com/questions/59838/how-can-i-check-if-a-directory-exists-in-a-bash-shell-script
#..................................................................................

#..................................................................................
# The main entry point for the script
#
main()
{
    # shellcheck source=/dev/null
    {
    . slb-helper.sh && return 0
    . slb-argadd.sh "$@"
    }

    # if -dir argument is empty, set it to current directory
    if [ -z ${dir+x} ] || [ "${dir}" == "" ] || [ "${dir}" == "-dir" ]; then dir=$PWD; fi

    # set variables
    setMingw64Var
    setWishVar
    setGitguiVar

    # check if has changes
    if [[ $(git status "$dir" --porcelain) ]]; then
        # invoke git-gui
        eval "\"$wish\" \"$gitgui\" \"--working-dir\" \"$dir\"";
    fi
}

#..................................................................................
# Set mingw64 dir to a variable
#
setMingw64Var()
{
    if [[ "$(slb-ostype.sh)" == "WINDOWS" ]]; then
        mingw64="$(cygpath -m "$PROGRAMFILES")/Git/mingw64"
    else
        mingw64="TODO"
    fi

    # if directory doesn't exist.
    [ ! -d "$mingw64" ] && echo "Couldn't find mingw64 at \"$mingw64\"" & return 1
}

#..................................................................................
# Set wish dir to a variable
#
setWishVar()
{
    if [[ "$(slb-ostype.sh)" == "WINDOWS" ]]; then
        wish="$mingw64/bin/wish.exe"
    else
        wish="TODO"
    fi

    # if file doesn't exist.
    [ ! -f "$wish" ] && echo "Couldn't find wish at \"$wish\"" & return 1
}

#..................................................................................
# Set git-gui dir to a variable
#
setGitguiVar()
{
    if [[ "$(slb-ostype.sh)" == "WINDOWS" ]]; then
        gitgui="$mingw64/libexec/git-core/git-gui"
    else
        gitgui="TODO"
    fi

    # if file doesn't exist.
    [ ! -f "$gitgui" ] && echo "Couldn't find git-gui at \"$gitgui\"" & return 1
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Wish git-gui if status has changes.
#/
#/ slb-git-guider.sh [-dir:] [-v] [/?]
#/   -dir       Directory of the repository
#/   -v         Shows the script version
#/   /?         Shows this help