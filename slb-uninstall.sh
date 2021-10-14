#!/bin/sh
#slb-uninstall.sh Version 0.1
#..................................................................................
# Description:
#   Install ScriptLib.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://grabthiscode.com/shell/bash-how-to-remove-the-first-n-lines-of-a-file
#     -> https://stackoverflow.com/questions/20158559/how-to-read-specific-lines-in-a-file-in-bash
#..................................................................................

#..................................................................................
# The main entry point for the script
#
main()
{
    # go to System directory
    system=$PWD"/src/sh/System"

    # default help
    . $system/slb-helper.sh && return 0

    # parse the arguments
    . $system/slb-argadd.sh "$@"

    # if not quiet
    if [ -z ${q+x} ]; then echo "Uninstalling ScriptLib..."; fi

    # clean .bash_profile
    cleanBashProfile $q

    # if not quiet
    if [ -z ${q+x} ]; then echo "Done!"; fi
}

#..................................................................................
# Clean .bash_profile
#
cleanBashProfile()
{
    line2="# ScriptLib"
    line16="#.................................................................................."
    sline2=$(sed -n '2p' $HOME/.bash_profile)
    sline16=$(sed -n '16p' $HOME/.bash_profile)

    # check if need to remove lines
    if [ "$line2" == "$sline2" ] && [ "$line16" == "$sline16" ]; then
        # Remove the first 17 lines in place
        sed -i 1,17d "$HOME/.bash_profile"
    fi

    # reload
    source "$HOME/.bash_profile"

    # if not quiet
    if [ "$1" != "-q" ]; then
        echo
        echo User variables:
        echo
        echo $PATH
        echo
    fi
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Uninstall ScriptLib (Modifies environment variables in the user environment).
#/
#/ slb-uninstall.sh [-v] [/?]
#/   -q         Quiet
#/   -v         Shows the script version
#/   /?         Shows this help