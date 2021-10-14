#!/bin/bash
#slb.sh Version 0.1
#..................................................................................
# Description:
#   ScriptLib command invoker
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://linuxize.com/post/how-to-create-bash-aliases/
#     -> https://stackoverflow.com/questions/37104273/how-to-set-aliases-in-the-git-bash-for-windows
#     -> https://www.baeldung.com/linux/delete-lines-containing-string-from-file
#..................................................................................

#..................................................................................
# The main entry point for the script
#
main()
{
    # default help
    if [ "$1" == "-v" ] || [ "$1" == "--version" ] || [ "$1" == "--help" ] || [ "$1" == "/?" ]; then
        . slb-helper.sh && return 0
    fi

    # get all arguments but first and invoke the script
    if [ "$1" != "" ]; then slb-$1.sh ${@:2}; fi
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ ScriptLib command invoker.
#/
#/ slb [command] [-v] [/?]
#/   argadd      Parse and define args.
#/   config      Configurations for ScriptLib.
#/   helper      Performs file documentation analysis.
#/   ostype      Detect Operational System type.
#/   symlnk      Create NTFS (Windows) links that is usable by Windows and Cygwin.
#/   git-scfdng  Scaffolding.
#/   git-ckeckr  TODO
#/   git-getter  TODO
#/   git-guider  TODO
#/   git-lister  TODO
#/   git-puller  TODO
#/   git-sender  TODO
#/   git-stater  TODO
#/   git-updter  TODO
#/   net-shdlib  TODO
#/   -v          Shows the batch version
#/   /?          Help
#/