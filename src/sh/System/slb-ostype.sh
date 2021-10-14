#!/bin/bash
#slb-ostype.sh Version 0.1
#..................................................................................
# Description:
#   Detect Operational System type.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
#     -> https://stackoverflow.com/questions/16905183/dash-double-semicolon-syntax
#..................................................................................

#..................................................................................
# The main entry point for the script
#
main()
{
    # default help
    . slb-helper.sh && return 0

    # detect Operational System type
    case "$OSTYPE" in
        solaris*) echo "SOLARIS" ;;
        darwin*)  echo "OSX" ;;
        linux*)   echo "LINUX" ;;
        bsd*)     echo "BSD" ;;
        msys*)    echo "WINDOWS" ;;
        cygwin*)  echo "WINDOWS" ;;
        *)        echo "unknown: $OSTYPE" ;;
    esac
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Detect Operational System type.
#/
#/ slb-ostype.sh [-v] [/?]
#/   -v         Shows the script version
#/   /?         Shows this help