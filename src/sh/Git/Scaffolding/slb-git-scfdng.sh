#!/bin/bash
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
#     -> https://reactgo.com/bash-remove-first-character-of-string/
#     -> https://stackoverflow.com/questions/3790101/bash-script-regex-to-get-directory-path-up-nth-levels
#     -> https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
#     -> https://www.cyberciti.biz/faq/finding-bash-shell-array-length-elements/
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

    # shellcheck disable=SC2154,SC2086
    if unvalued "ds" $ds; then return 1; fi

    # shellcheck disable=SC2154,SC2086
    if defined $dm; then

        if unvalued "dm" $dm; then return 1; fi

        # read values
        readDs "$ds" && readDm "$dm"

        # generate .NET superproject/submodule
        slb-git-scf-net-genspm.sh -sd:"$dsdir" -su:"$dsups" -sn:"$dsnam" -md:"$dmdir" -mu:"$dmups" -mn:"$dmnam"

    elif defined $dc; then

        if unvalued "dc" $dc; then return 1; fi

        # read values
        readDs "$ds" && readDc "$dc"

        # generate .NET superproject/core submodule
        slb-git-scf-net-genspm.sh -sd:"$dsdir" -su:"$dsups" -sn:"$dsnam" -cd:"$dcdir" -cu:"$dcups" -cn:"$dcnam"
    else
        echo "-dm or dc is not defined"
    fi
}

#..................................................................................
# Read ds values
#
readDs()
{
    IFS=']' read -ra ADDR <<< "$1"
    length=${#ADDR[@]}

    if [ "$length" == "1" ]; then
        dsdir=$PWD
        dsups="$(slb.sh config -g:"upsurl")"
        dsnam=${ADDR[0]} && if [[ $dsnam = [* ]]; then dsnam=${ADDR[0]:1}; fi
    elif [ "$length" == "2" ]; then
        dsdir=$PWD
        dsups=${ADDR[0]} && if [[ $dsups = [* ]]; then dsups=${ADDR[0]:1}; fi
        dsnam=${ADDR[1]} && if [[ $dsnam = [* ]]; then dsnam=${ADDR[1]:1}; fi
    elif [ "$length" == "3" ]; then
        dsdir=${ADDR[0]} && if [[ $dsdir = [* ]]; then dsdir=${ADDR[0]:1}; fi
        dsups=${ADDR[1]} && if [[ $dsups = [* ]]; then dsups=${ADDR[1]:1}; fi
        dsnam=${ADDR[2]} && if [[ $dsnam = [* ]]; then dsnam=${ADDR[2]:1}; fi
    fi
}

#..................................................................................
# Read dm values
#
readDm()
{
    IFS=']' read -ra ADDR <<< "$1"
    length=${#ADDR[@]}

    if [ "$length" == "1" ]; then
        dmdir=$PWD
        dmups="$(slb.sh config -g:"upsurl")"
        dmnam=${ADDR[0]} && if [[ $dmnam = [* ]]; then dmnam=${ADDR[0]:1}; fi
    elif [ "$length" == "2" ]; then
        dmdir=$PWD
        dmups=${ADDR[0]} && if [[ $dmups = [* ]]; then dmups=${ADDR[0]:1}; fi
        dmnam=${ADDR[1]} && if [[ $dmnam = [* ]]; then dmnam=${ADDR[1]:1}; fi
    elif [ "$length" == "3" ]; then
        dmdir=${ADDR[0]} && if [[ $dmdir = [* ]]; then dmdir=${ADDR[0]:1}; fi
        dmups=${ADDR[1]} && if [[ $dmups = [* ]]; then dmups=${ADDR[1]:1}; fi
        dmnam=${ADDR[2]} && if [[ $dmnam = [* ]]; then dmnam=${ADDR[2]:1}; fi
    fi
}

#..................................................................................
# Read dc values
#
readDc()
{
    IFS=']' read -ra ADDR <<< "$1"
    length=${#ADDR[@]}

    if [ "$length" == "1" ]; then
        dcdir=$PWD
        dcups="$(slb.sh config -g:"upsurl")"
        dcnam=${ADDR[0]} && if [[ $dcnam = [* ]]; then dcnam=${ADDR[0]:1}; fi
    elif [ "$length" == "2" ]; then
        dcdir=$PWD
        dcups=${ADDR[0]} && if [[ $dcups = [* ]]; then dcups=${ADDR[0]:1}; fi
        dcnam=${ADDR[1]} && if [[ $dcnam = [* ]]; then dcnam=${ADDR[1]:1}; fi
    elif [ "$length" == "3" ]; then
        dcdir=${ADDR[0]} && if [[ $dcdir = [* ]]; then dcdir=${ADDR[0]:1}; fi
        dcups=${ADDR[1]} && if [[ $dcups = [* ]]; then dcups=${ADDR[1]:1}; fi
        dcnam=${ADDR[2]} && if [[ $dcnam = [* ]]; then dcnam=${ADDR[2]:1}; fi
    fi
}

#..................................................................................
# Check if variable is empty
#
unvalued()
{
    # if variable is unset or set to the empty string
    if [ -z ${2+x} ]; then
        echo "-${1} is empty"
        return 0 # true
    fi

    # if variable is set to it´s own name
    if [ "${2}" == "-${1}" ]; then
        echo "-${1} is empty"
        return 0 # true
    fi

    return 1 # false
}

#..................................................................................
# Check if variable is defined
#
defined()
{
    # if variable is unset or set to the empty string
    if [ -z ${1+x} ]; then
        return 1 # false
    fi

    return 0 # true
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
#/ slb-git-scfdng.sh <-ds:> [-dm:] [-dc] [-v] [/?]
#/   -ds:[dir][upstream]<name>   Superproject structure for .NET
#/                               - If [dir] is ommited, current will be used
#/                               - If [upstream] is ommited, upsurl variable will be used
#/   -dm:[dir][upstream]<name>   Submodule structure for .NET
#/                               - If [dir] is ommited, current will be used
#/                               - If [upstream] is ommited, upsurl variable will be used
#/   -dc:[dir][upstream]<name>   Submodule core structure for .NET
#/                               - If [dir] is ommited, current will be used
#/                               - If [upstream] is ommited, upsurl variable will be used
#/   -v                          Shows the script version
#/   /?                          Shows this help
#/
#/ Sample:
#/   slb git-scfdng -ds:"[Project]" -dc:"[Module]"
#/   slb git-scfdng -ds:"[Project]" -dm:"[Module]"
#/   slb git-scfdng -ds:"[https://github.com/foo/][Project]" -dm:"[https://company@dev.azure.com/project/][Module]"
#/   slb git-scfdng -ds:"[C:\Users\Foo][https://gitlab.com/foo/][Project]" -dm:"[Module]"