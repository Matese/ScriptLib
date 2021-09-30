#!/bin/sh
#slb-git-getter.sh Version 0.1
#..................................................................................
# Description:
#   Clone superproject and it´s submodules
#
# History:
#   - v0.1 2021-09-23 Initial release including basic documentation
#
# Remarks:
#   Inspired by
#     -> https://stackoverflow.com/questions/8967902/why-do-you-need-to-put-bin-bash-at-the-beginning-of-a-script-file
#     -> https://stackoverflow.com/questions/18096670/what-does-z-mean-in-bash
#

#..................................................................................
# The main entry point for the script
#
main()
{
    if [ -z "$1" ]; then
        echo "fatal: (null) is not a git repository"
    else
        if [ -z "$2" ]; then
            echo "fatal: unexpected branch"
        else
            git clone "http://tfs.larnet:8080/tfs/DESENVOLVIMENTO/LARGIT/_git/${1}_super"
            cd "${1}_super"
            git submodule update --init
            git submodule foreach git checkout ${2}
            git checkout ${2}
        fi;
    fi;
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
#/ slb-git-getter.sh [-dir:] [-v] [/?]
#/   -dir       Directory of the repository
#/   -v         Shows the script version
#/   /?         Shows this help
#/