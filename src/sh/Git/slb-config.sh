#!/bin/bash
#slb-config.sh Version 0.1
#..................................................................................
# Description:
#   Configurations for ScriptLib.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://unix.stackexchange.com/questions/175648/use-config-file-for-my-shell-script
#     -> https://linuxize.com/post/bash-check-if-file-exists/
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

    # get
    if [ ! -z ${g+x} ]; then
        if [ "${g}" == "" ] || [ "${g}" == "-g" ]; then echo "-g is not defined" & return 1; fi
        getConfig $g
    fi

    # delete
    if [ ! -z ${d+x} ]; then
        if [ "${d}" == "" ] || [ "${d}" == "-d" ]; then echo "-d is not defined" & return 1; fi
        delConfig $d
    fi

    # set key/value
    if [ ! -z ${sk+x} ] && [ ! -z ${sv+x} ]; then
        if [ "${sk}" == "" ] || [ "${sk}" == "-sk" ]; then echo "-sk is not defined" & return 1; fi
        if [ "${sv}" == "" ] || [ "${sv}" == "-sv" ]; then echo "-sv is not defined" & return 1; fi
        setConfig $sk $sv
    fi
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
#/ Configurations for ScriptLib.
#/
#/ slb-config.sh [-g:] [-d:] [-sk:-sv:] [-v] [/?]
#/   -g:        Get a configuration
#/   -d:        Delete a configuration
#/   -sk:       Set configuration key
#/   -sv:       Set configuration value
#/   -v         Shows the script version
#/   /?         Shows this help
#/
#/ Possible configurations are:
#/   gsups      Git Scaffolding Upstream