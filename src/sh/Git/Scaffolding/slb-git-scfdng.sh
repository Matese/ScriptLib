#!/bin/sh
#slb-git-scfdng.sh Version 0.1
#..................................................................................
# Description:
#   Scaffolding
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://stackoverflow.com/questions/3790101/bash-script-regex-to-get-directory-path-up-nth-levels
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

    # default arguments
    if [ -z ${d+x} ] || [ "${d}" == "" ] || [ "${d}" == "-d" ]; then d=$PWD; fi

    # check for empty arguments
    if [ -z ${n+x} ] || [ "${n}" == "" ] || [ "${n}" == "-n" ]; then echo "-n is not defined" & return 1; fi

    # .NET superproject
    if [ ! -z ${dnsp+x} ]; then slb-git-scf-net-spbase.sh -d:"${d}" -n:"${n}"; fi

    # .NET submodule
    if [ ! -z ${dnsm+x} ]; then slb-git-scf-net-smbase.sh -d:"${d}" -n:"${n}"; fi
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Scaffolding.
#/
#/ slb-git-scfdng.sh <-n:> [-d:] [-dotnetsp] [-dotnetsm] [-v] [/?]
#/   -n:        Project name
#/   -d:        Directory
#/   -dnsp      Superproject structure for .NET
#/   -dnsm      Submodule structure for .NET
#/   -v         Shows the script version
#/   /?         Shows this help