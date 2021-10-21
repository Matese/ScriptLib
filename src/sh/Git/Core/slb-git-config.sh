#!/bin/bash
#slb-git-config.sh Version 0.1
#..................................................................................
# Description:
#   Create git configurations.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://github.com/koalaman/shellcheck
#     -> https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
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

    # get
    # shellcheck disable=SC2154,SC2086
    if defined $g; then
        if unvalued "g" $g; then return 1; fi
        getConfig "$g"
        return 0;
    fi

    # delete
    # shellcheck disable=SC2154,SC2086
    if defined $d; then
        if unvalued "d" $d; then return 1; fi
        delConfig "$d"
        echo "Configuration deleted!"
        return 0;
    fi

    # set key/value
    # shellcheck disable=SC2154,SC2086
    if defined $sk && defined $sb; then
        if unvalued "sk" $sk; then return 1; fi
        if unvalued "sv" $sv; then return 1; fi
        setConfig "$sk" "$sv"
        echo "Configuration updated!"
        return 0;
    fi

    # shellcheck disable=SC2154,SC2086
    {
    if unvalued "n" $n; then return 1; fi
    if unvalued "e" $e; then return 1; fi
    }

    # git config
    gitConfig
    echo "Configuration created!"
}

#..................................................................................
# Create Git configuration
#
gitConfig()
{
    # create .gitconfig file name
    gitconfig=$HOME/.gitconfig

    # delete old .gitconfig file if exists
    if [ -f "$gitconfig" ]; then rm "$gitconfig"; fi

    # create new .gitconfig file
    touch "$gitconfig"

    # get this script path
    scriptdir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

    # write content to .gitconfig file
    {
        echo "[core]"
        echo "	symlinks = true"
        echo "[user]"
        echo "	name = $n"
        echo "	email = $e"
        echo "[alias]"
        echo "	puller = !bash $scriptdir/slb-git-puller.sh"
        echo "	getter = !bash $scriptdir/slb-git-getter.sh"
        echo "	lister = !bash $scriptdir/slb-git-lister.sh"
        echo "	sender = !bash $scriptdir/slb-git-sender.sh"
        echo "	updter = !bash $scriptdir/slb-git-updter.sh"
        echo "	checkr = !bash $scriptdir/slb-git-checkr.sh"
        echo "	stater = !bash $scriptdir/slb-git-stater.sh"
        echo "	guider = !bash $scriptdir/slb-git-guider.sh"
    } >> "$gitconfig"
}

#..................................................................................
# Get configuration
#
getConfig()
{
    (grep -E "^${1}=" -m 1 "$HOME/.scriptlib" 2>/dev/null || echo "VAR=__UNDEFINED__") | head -n 1 | cut -d '=' -f 2-;
}

#..................................................................................
# Set configuration
#
setConfig()
{
    delConfig "$1"
    echo "$1=$2" >> "$HOME/.scriptlib"
}

#..................................................................................
# Delete configuration
#
delConfig()
{
    test -f "$HOME/.scriptlib" && sed -i "/^$(echo "$1" | sed -e 's/[]\/$*.^[]/\\&/g').*$/d" "$HOME/.scriptlib"
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
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Create git configurations.
#/
#/ slb-git-config [-n:] [-e:] [-g:] [-d:] [-sk:-sv:] [-v] [/?]
#/   -n:       The name of the user
#/   -e:       The email of the user
#/   -g:       Get a configuration
#/   -d:       Delete a configuration
#/   -sk:      Set configuration key
#/   -sv:      Set configuration value
#/   -v        Shows the script version
#/   /?        Shows this help
#/
#/ Possible configurations are:
#/   upsurl     Upstream URL
#/   upsgid     Upstream Group ID
#/   upsapi     Upstream API Authorization Token
#/
#/ Sample:
#/    slb-git-config -n:"Juca Pirama" -e:jucapirama@bixao.com.br
#/    slb-git-config -sk:upsurl -sv:"C:/Users/Bixao/Repos"