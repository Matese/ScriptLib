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
    # default help
    . slb-helper.sh && return 0

    # shellcheck source=/dev/null
    # parse the arguments
    . slb-argadd.sh "$@"

    # get
    if [ ! -z ${g+x} ]; then
        if [ "${g}" == "" ] || [ "${g}" == "-g" ]; then echo "-g is not defined" & return 1; fi
        getConfig $g
        return 0;
    fi

    # delete
    if [ ! -z ${d+x} ]; then
        if [ "${d}" == "" ] || [ "${d}" == "-d" ]; then echo "-d is not defined" & return 1; fi
        delConfig $d
        echo "Configuration deleted!"
        return 0;
    fi

    # set key/value
    if [ ! -z ${sk+x} ] && [ ! -z ${sv+x} ]; then
        if [ "${sk}" == "" ] || [ "${sk}" == "-sk" ]; then echo "-sk is not defined" & return 1; fi
        if [ "${sv}" == "" ] || [ "${sv}" == "-sv" ]; then echo "-sv is not defined" & return 1; fi
        setConfig $sk $sv
        echo "Configuration updated!"
        return 0;
    fi

    # check if will set user
    if [ ! -z ${n+x} ] && [ ! -z ${e+x} ]; then
        u="true"
        if [ -z ${n+x} ] || [ "${n}" == "" ] || [ "${n}" == "-n" ]; then u="false"; fi
        if [ -z ${e+x} ] || [ "${e}" == "" ] || [ "${e}" == "-e" ]; then u="false"; fi
        gitConfig
        echo "Configuration created!"
        return 0;
    fi

    echo "Nothing to do!"
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
        if [ "$u" == "true" ]; then echo "[user]"; fi
        if [ "$u" == "true" ]; then echo "	name = $n"; fi
        if [ "$u" == "true" ]; then echo "	email = $e"; fi
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
    test -f "$HOME/.scriptlib" && sed -i "/^$(echo $1 | sed -e 's/[]\/$*.^[]/\\&/g').*$/d" "$HOME/.scriptlib"
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
#/   gsups      Git Scaffolding Upstream
#/
#/ Sample:
#/    slb-git-config -n:"Juca Pirama" -e:jucapirama@bixao.com.br
#/    slb-git-config -sk:gsups -sv:"C:/Users/Bixao/Repos"