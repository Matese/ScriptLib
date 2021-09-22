#!/bin/sh
#slb-helper.sh Version 0.1
#..................................................................................
# Description:
#   Performs file documentation analysis.
#
# History:
#   - v0.1 2020-09-10 Initial release including basic documentation
#
# Remarks:
#   This script has the premise that the script passed as argument has the same
#   documentation convention as this script. In other words, the script passed as
#   argument should have "#/" before documentation lines.
#
#   Sample 1: Show this script help
#   > slb-helper.sh --help
#

#..................................................................................
# The main entry point for the script
#
main()
{
    # shows the script version
    expr "$*" : ".*--version" > /dev/null && showVersion

    # shows the help
    expr "$*" : ".*--help" > /dev/null && showHelp
}

#..................................................................................
# Shows the documentation
#
showHelp()
{
    grep '^#/' "$0" | cut -c4-;
    exit 0;
}

#..................................................................................
# Shows the version
#
showVersion()
{
    # https://www.cyberciti.biz/faq/howto-use-cat-command-in-unix-linux-shell-script/
    # https://stackoverflow.com/questions/16136943/how-to-get-the-second-column-from-command-output
    cat ${0} | head -2 | tail -1 | sed 's/#//'
    exit 0;
}

#..................................................................................
# Calls the main script, inspired by:
# - https://unix.stackexchange.com/questions/449498/call-function-declared-below
#
main "$@";

#..................................................................................
#..HELP...
#/
#/ Performs sh file analysis discovering and displaying documentation if any.
#/ Documentation should follow the convention defined at the end of the script.
#/
#/   slb-helper <FilePath> [--version] [--help]
#/   FilePath   File path to parse
#/   --version  Shows the script version
#/   --help     Shows this help