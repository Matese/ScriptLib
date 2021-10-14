#!/bin/bash
#slb-install.sh Version 0.1
#..................................................................................
# Description:
#   Install ScriptLib.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://linuxbsdos.com/2014/11/26/how-to-set-the-path-variable-in-bash/
#     -> https://stackoverflow.com/questions/2154166/how-to-recursively-list-subdirectories-in-bash-without-using-find-or-ls-comm
#     -> https://reactgo.com/bash-remove-last-character-of-string/
#     -> https://stackoverflow.com/questions/9533679/how-to-insert-a-text-at-the-beginning-of-a-file
#     -> https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash
#     -> https://stackoverflow.com/questions/30988586/creating-an-array-from-a-text-file-in-bash
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
    if [ -z ${q+x} ]; then echo "Installing ScriptLib..."; fi

    # uninstall quietly
    $PWD"/slb-uninstall.sh" -q

    # create .bash_profile
    createBashProfile $q

    # if not quiet
    if [ -z ${q+x} ]; then echo "Done!"; fi
}

#..................................................................................
# List directories recursively
#
listDirs() {
    for i in "$1"/*;do
        if [ -d "$i" ];then
            dirs="$dirs$i:"
            listDirs "$i"
        fi
    done
}

#..................................................................................
# Create .bash_profile
#
createBashProfile()
{
    # create file if not exits
    if [ ! -e "$HOME/.bash_profile" ] ; then touch "$HOME/.bash_profile"; fi

    # if file is empty, add a line to enable sed to work
    [ -s $HOME/.bash_profile ] || echo "" >> "$HOME/.bash_profile"

    # declare the array
    declare -a arr=()

    # aliases
    arr+=("")
    arr+=("#..................................................................................")
    arr+=("")
    arr+=("alias slb=\'slb.sh\'")
    arr+=("# Aliases")

    # ScriptLib dir
    listDirs $PWD/src
    slb=$dirs
    slb=${slb%?} # removes the last character

    # environment variables
    arr+=("")
    arr+=("export PATH")
    arr+=("PATH=\$PATH:\$SCRIPT_LIB")
    arr+=("export SCRIPT_LIB")
    arr+=("SCRIPT_LIB=${slb//\//\\\/}") # add \ before every /
    arr+=("# Environment variables")
    arr+=("")
    arr+=("if [ -f ~\/.bashrc ]; then . ~\/.bashrc; fi")
    arr+=("# Get the aliases and functions")
    arr+=("")
    arr+=("# ScriptLib")
    arr+=("#..................................................................................")

    # inverted order from array
    for i in "${arr[@]}"; do sed -i "1s/^/$i\n/" "$HOME/.bash_profile"; done

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
#/ Install ScriptLib (Modifies environment variables in the user environment).
#/
#/ slb-install.sh [-v] [/?]
#/   -q         Quiet
#/   -v         Shows the script version
#/   /?         Shows this help