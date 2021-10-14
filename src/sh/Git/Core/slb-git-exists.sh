#!/bin/bash
#slb-git-exists.sh Version 0.1
#..................................................................................
# Description:
#   Check for reachable git remote url.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://superuser.com/questions/227509/git-ping-check-if-remote-repository-exists
#..................................................................................

#..................................................................................
# The main entry point for the script
#
main()
{
    # default help
    . slb-helper.sh && return 0

    # parse the arguments
    . slb-argadd.sh "$@"

    # check for empty arguments
    if [ -z ${url+x} ] || [ "${url}" == "" ] || [ "${url}" == "-url" ]; then echo "-url is not defined" & return 1; fi

    # check
    if gitExists "$url"; then
        echo true
    else
        echo false
    fi
}

#..................................................................................
# Returns errlvl 0 if $1 is a reachable git remote url
#
gitExists()
{
    git ls-remote "$1" CHECK_GIT_REMOTE_URL_REACHABILITY >/dev/null 2>&1
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Check for reachable git remote url.
#/
#/ slb-git-exists.sh [-dir:] [-v] [/?]
#/   -url       Directory of the repository
#/   -v         Shows the script version
#/   /?         Shows this help