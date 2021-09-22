#!/bin/sh
#wisher.sh Version 0.1
#..................................................................................
# Description:
#   Wish git-gui if status has changes.
#
# History:
#   - v0.1 2020-09-10 Initial release including basic documentation
#
# Remarks:
#   TODO
#

#..................................................................................
# The main entry point for the script
#
main()
{
    WISH='"C:/Program Files/Git/mingw64/bin/wish.exe" '
    GITGUI='"C:/Program Files/Git/mingw64/libexec/git-core/git-gui" "--working-dir" '

    if [[ `git status ${1} --porcelain` ]];
    then
        eval $WISH$GITGUI\"$1\"
    fi
}

#..................................................................................
# Parse help and calls the main script
# - https://stackoverflow.com/questions/8352851/how-to-call-one-shell-script-from-another-shell-script
# - https://unix.stackexchange.com/questions/449498/call-function-declared-below
#
. ${PWD}/lar-help.sh
main "$@"; exit

#..................................................................................
#..HELP...
#/
#/ Wish git-gui if status has changes.
#/
#/   wisher TODO [--version] [--help]
#/   TODO       TODO
#/   --version  Shows the script version
#/   --help     Shows this help