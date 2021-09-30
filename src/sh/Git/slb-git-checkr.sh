#!/bin/sh
#slb-git-checkr.sh Version 0.1
#..................................................................................
# Description:
#   Check for changes in superproject and it´s submodules
#
# History:
#   - v0.1 2021-09-23 Initial release including basic documentation
#
# Remarks:
#   Inspired by
#     -> TODO
#

#..................................................................................
# The main entry point for the script
#
main()
{
    # check if is a git repository directory
    if [ -d .git ]; then
        echo "checking submodules..." && git submodule foreach --quiet 'git guider $toplevel/$name' 
        echo "checking superproject..." && git guider $PWD
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
#/ Wish git-gui if status has changes.
#/
#/ slb-git-checkr.sh [-dir:] [-v] [/?]
#/   -dir       Directory of the repository
#/   -v         Shows the script version
#/   /?         Shows this help
#/