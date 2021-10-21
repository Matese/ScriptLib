#!/bin/bash
#slb-git-checkr.sh Version 0.1
#..................................................................................
# Description:
#   Check for changes in superproject and it´s submodules
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
    # shellcheck source=/dev/null
    {
    . slb-helper.sh && return 0
    . slb-argadd.sh "$@"
    }

    # check if is a git repository directory
    if [ -d .git ]; then
        # shellcheck disable=SC2016
        echo "checking submodules..." && git submodule foreach --quiet 'git guider $toplevel/$name'
        echo "checking superproject..." && git guider "$PWD"
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
#/ slb-git-checkr.sh [-v] [/?]
#/   -v         Shows the script version
#/   /?         Shows this help