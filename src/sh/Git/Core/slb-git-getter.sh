#!/bin/bash
#slb-git-getter.sh Version 0.1
#..................................................................................
# Description:
#   Clone superproject and it´s submodules
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://stackoverflow.com/questions/8967902/why-do-you-need-to-put-bin-bash-at-the-beginning-of-a-script-file
#     -> https://stackoverflow.com/questions/18096670/what-does-z-mean-in-bash
#..................................................................................

#..................................................................................
# The main entry point for the script
#
main()
{
    # shellcheck source=/dev/null
    # default help
    . slb-helper.sh && return 0

    # shellcheck source=/dev/null
    # parse the arguments
    . slb-argadd.sh "$@"

    # check for empty arguments
    if [ -z ${r+x} ] || [ "${r}" == "" ] || [ "${r}" == "-r" ]; then echo "-r is not defined" & return 1; fi
    if [ -z ${b+x} ] || [ "${b}" == "" ] || [ "${b}" == "-b" ]; then echo "-b is not defined" & return 1; fi

    # cache file
    f=$HOME/.scriptlib.lister

    # if cache file does not exist, call lister to create it
    if [[ ! -f $f ]]; then .slb.sh lister; fi

    # read cache file
    readarray arr < $f

    # loop cache file
    for ((i=1;i<=${#arr[@]};i++)); do
        line=$(echo ${arr[i]}|xargs)
        if [ "${line:0:5}" = "Repo:" ]; then
            if [ "${line:6}" == "$1" ]; then
                url=$(echo ${arr[i+2]}|xargs) && url=${url:6}
                git clone "$url"
                cd "${1}"
                git submodule update --init
                git submodule foreach git checkout ${2}
                git checkout ${2}
                break
            fi
        fi
    done
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
#/ slb-git-getter.sh <-r:> <-b:> [-v] [/?]
#/   -r         Repo
#/   -b         Branch
#/   -v         Shows the script version
#/   /?         Shows this help