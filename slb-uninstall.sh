#!/bin/bash
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
    # shellcheck source=/dev/null
    . "$system/slb-helper.sh" && return 0

    # parse the arguments
    # shellcheck source=/dev/null
    . "$system/slb-argadd.sh" "$@"

    # if not quiet
    if [ -z ${q+x} ]; then echo "Uninstalling ScriptLib..."; fi

    # clean .bash_profile
    cleanBashProfile "$q"

    # if not quiet
    if [ -z ${q+x} ]; then echo "Done!"; fi
}

#..................................................................................
# Clean .bash_profile
#
cleanBashProfile()
{
    # create file if not exits
    if [ ! -e "$HOME/.bash_profile" ] ; then touch "$HOME/.bash_profile"; fi

    # if file is empty, add a line to enable sed to work
    [ -s "$HOME/.bash_profile" ] || echo "" >> "$HOME/.bash_profile"

    # variables
    line2="# ScriptLib"
    line16="#.................................................................................."
    sline2=$(sed -n '2p' "$HOME/.bash_profile")
    sline16=$(sed -n '16p' "$HOME/.bash_profile")

    # check if need to remove lines
    if [ "$line2" == "$sline2" ] && [ "$line16" == "$sline16" ]; then
        # Remove the first 17 lines in place
        sed -i 1,17d "$HOME/.bash_profile"
    fi

    # reload
    # shellcheck source=/dev/null
    source "$HOME/.bash_profile"

    # if not quiet
    if [ "$1" != "-q" ]; then
        echo
        echo User variables:
        echo
        echo "$PATH"
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