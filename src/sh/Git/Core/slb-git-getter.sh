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
#     -> https://stackoverflow.com/questions/18096670/what-does-z-mean-in-bash
#     -> https://stackoverflow.com/questions/8967902/why-do-you-need-to-put-bin-bash-at-the-beginning-of-a-script-file
#     -> https://www.cyberciti.biz/faq/see-check-if-bash-variable-defined-in-script-on-linux-unix-macos/
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
    {
    if unvalued "r" $r; then return 1; fi
    if unvalued "b" $f >/dev/null ; then b="master"; fi
    }

    # cache file
    f=$HOME/.scriptlib.lister

    # call lister to rebuild cache if file inexists
    if inexists "$f"; then .slb.sh lister; fi

    # read cache file
    readarray arr <"$f"

    # loop cache file
    for ((i = 1; i <= ${#arr[@]}; i++)); do

        # if repo line found
        if repo "${arr[i]}"; then

            # get the repository url
            url="$(url "${arr[i + 2]}")"

            # check if just want to get the URL
            # shellcheck disable=SC2154,SC2086
            if defined $u; then
                echo "$url"
            else
                # clone the url (that will be found two lines down)
                git clone "$url"

                # go to cloned dir
                cd "${PWD}/$r" || exit

                # initialize the repository
                init "$url" "$b"
            fi

            return 0 # true
        fi

    done

    echo "Reporitory not found!"

    return 1 # false
}

#..................................................................................
# Initialize repo
#
init()
{
    if super "$1"; then
        git submodule update --init
        git submodule foreach git checkout "${2}"
    fi

    git checkout "$2"
}

#..................................................................................
# Check if repo is a superproject
#
super()
{
    # create a temp dir and cd into it
    tempdir=$(mktemp -d) && cd "$tempdir" || exit

    # inialize a empty repo and fetch
    git init > /dev/null 2>&1 && git fetch --depth=1 "$1" > /dev/null 2>&1

    # check if repo is a superproject
    if git rev-parse --verify --quiet FETCH_HEAD:.root >/dev/null; then
        found=true
    fi

    # come back delete temp dir
    cd .. && rm -rf tempdir

    if [ $found ]; then
        return 0 # true
    else
        return 1 # false
    fi
}

#..................................................................................
# Print url
#
url()
{
    url=$(echo "$1" | xargs)
    url=${url:6}
    echo "$url"
}

#..................................................................................
# Find repository line
#
repo()
{
    line=$(echo "$1" | xargs)

    if [ "${line:0:5}" = "Repo:" ]; then

        if [ "${line:6}" == "$r" ]; then
             return 0 # true
        fi

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
# Check if file inexists
#
inexists()
{
    # if file do not exist
    if [[ ! -f $1 ]]; then
        return 0 # true
    fi

    return 1 # false
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Clone superproject and it´s submodules
#/
#/ slb-git-getter.sh <-r:> [-b:] [-u] [-v] [/?]
#/   -r         Repo
#/   -b         Branch
#/   -u         Do not clone, just get the reporitory URL
#/   -v         Shows the script version
#/   /?         Shows this help
