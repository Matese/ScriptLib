#!/bin/sh
#slb-helper.sh Version 0.1
#..................................................................................
# Description:
#   Performs file documentation analysis.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   This script has the premise that the script passed as argument has the same
#   documentation convention as this script. In other words, the script passed as
#   argument should have "#/" before documentation lines.
#
#   Inspired by
#     -> https://www.cyberciti.biz/faq/howto-use-cat-command-in-unix-linux-shell-script/
#     -> https://stackoverflow.com/questions/16136943/how-to-get-the-second-column-from-command-output
#     -> https://unix.stackexchange.com/questions/449498/call-function-declared-below
#     -> https://stackoverflow.com/questions/49857332/bash-exit-from-source-d-script
#     -> https://datacadamia.com/os/process/exit_code
#     -> https://unix.stackexchange.com/questions/79343/how-to-loop-through-arguments-in-a-bash-script
#     -> https://linuxize.com/post/bash-check-if-file-exists/
#     -> https://stackoverflow.com/questions/13788166/how-can-i-remove-the-first-part-of-a-string-in-bash
#..................................................................................

#..................................................................................
# The main entry point for the script
#
main()
{
    checkSource

    for i in "$@"; do
        if [ "$i" == "-v" ]; then
            showVersion && $exit 0
        elif [ "$i" == "--version" ]; then
            showVersion && $exit 0
        elif [ "$i" == "--help" ]; then
            showHelp && $exit 0
        elif [ "$i" == "/?" ]; then
            showHelp && $exit 0
        fi
    done

    $exit 1
}

#..................................................................................
# Find out how the script was invoked
#
checkSource()
{
    # we don't want to end the user's terminal session!
    if [[ "$0" != "$BASH_SOURCE" ]] ; then
        # this script is executed via `source`,
        # an `exit` will close the user's console
        exit=return
    else
        # this script is not `source`-d,
        # it's safe to exit via `exit`
        exit=exit
    fi
}

#..................................................................................
# Shows the documentation
#
showHelp()
{
    r=${0}

    # if file not found, move 3 levels up (root dir) and append file name
    if ! test -f "${0}"; then
        r=$(dirname ${PWD}); r=$(dirname ${r}); r=$(dirname ${r}); r=${r}/${0#*./};
    fi

    grep '^#/' "$r" | cut -c4-;
}

#..................................................................................
# Shows the version
#
showVersion()
{
    r=${0}

    # if file not found, move 3 levels up (root dir) and append file name
    if ! test -f "${0}"; then
        r=$(dirname ${PWD}); r=$(dirname ${r}); r=$(dirname ${r}); r=${r}/${0#*./};
    fi

    echo & cat ${r} | head -2 | tail -1 | sed 's/#//'
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Performs sh file analysis discovering and displaying documentation if any.
#/
#/ slb-helper.sh <FilePath> [-v] [/?]
#/   FilePath   File path to parse
#/   -v         Shows the script version
#/   /?         Shows this help