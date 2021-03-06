#!/bin/bash
#slb-git-stater.sh Version 0.1
#..................................................................................
# Description:
#   Check for status changes
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
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

    # if there is no param
    if [ -z "$1" ]; then
        dir=${PWD}; # dir receives current dir
    else
        dir=${1};   # dir receives the param
    fi

    # check if has changes
    if [[ $(git status "${dir}" --porcelain) ]]; then
        # save in file
        echo "There are changes in ${dir}" > /tmp/slb-git-stater.dat

        # print to the user
        # echo `cat /tmp/slb-git-stater.dat`
    fi;
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Check for status changes
#/
#/ slb-git-stater.sh [dir] [-v] [/?]
#/   dir        Directory of the repository
#/   -v         Shows the script version
#/   /?         Shows this help