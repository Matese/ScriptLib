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
#     -> https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
#     -> https://reactgo.com/bash-remove-first-character-of-string/
#     -> https://www.cyberciti.biz/faq/finding-bash-shell-array-length-elements/
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
    if [ -z ${ds+x} ] || [ "${ds}" == "" ] || [ "${ds}" == "-ds" ]; then echo "-ds is not defined" & return 1; fi

    # Generate .NET superproject/submodule
    if [ ! -z ${dm+x} ]; then

        if [ "${dm}" == "" ] || [ "${dm}" == "-dm" ]; then echo "-dm is not defined" & return 1; fi

        # read values
        readDs $ds
        readDm $dm

        # generate
        slb-git-scf-net-genspm.sh -sd:"$dsdir" -su:"$dsups" -sn:"$dsnam" -md:"$dmdir" -mu:"$dmups" -mn:"$dmnam"

    # Generate .NET superproject/core submodule
    elif [ ! -z ${dc+x} ]; then

        if [ "${dc}" == "" ] || [ "${dc}" == "-dc" ]; then echo "-dc is not defined" & return 1; fi

        # read values
        readDs $ds
        readDc $dc

        # generate
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
        dsups="$(slb.sh config -g:"gsups")"
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
        dmups="$(slb.sh config -g:"gsups")"
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
        dcups="$(slb.sh config -g:"gsups")"
        dcnam=${ADDR[0]} &&  if [[ $dcnam = [* ]]; then dcnam=${ADDR[0]:1}; fi
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
#/                               - If [upstream] is ommited, gsups variable will be used
#/   -dm:[dir][upstream]<name>   Submodule structure for .NET
#/                               - If [dir] is ommited, current will be used
#/                               - If [upstream] is ommited, gsups variable will be used
#/   -dc:[dir][upstream]<name>   Submodule core structure for .NET
#/                               - If [dir] is ommited, current will be used
#/                               - If [upstream] is ommited, gsups variable will be used
#/   -v                          Shows the script version
#/   /?                          Shows this help
#/
#/ Sample:
#/   slb git-scfdng -ds:"[Project]" -dc:"[Module]"
#/   slb git-scfdng -ds:"[Project]" -dm:"[Module]"
#/   slb git-scfdng -ds:"[https://github.com/foo/][Project]" -dm:"[https://company@dev.azure.com/project/][Module]"
#/   slb git-scfdng -ds:"[C:\Users\Foo][https://gitlab.com/foo/][Project]" -dm:"[Module]"