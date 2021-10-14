#!/bin/bash
#slb-git-puller.sh Version 0.1
#..................................................................................
# Description:
#   Pull superproject and it´s submodules
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> TODO
#..................................................................................

#..................................................................................
# The main entry point for the script
#
main()
{
    # check if is a git repository directory
    if [ -d .git ]; then
        if [ -z "$1" ]; then
            echo "fatal: (null) is not a valid branch"
        else
            git submodule foreach git pull origin ${1}
            git pull origin ${1}
        fi;
    else
        echo "fatal: not a git repository (or any of the parent directories)"
    fi;
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Pull superproject and it´s submodules.
#/
#/ slb-git-puller.sh [-dir:] [-v] [/?]
#/   -dir       Directory of the repository
#/   -v         Shows the script version
#/   /?         Shows this help