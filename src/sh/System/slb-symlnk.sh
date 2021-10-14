#!/bin/bash
#slb-symlnk.sh Version 0.1
#..................................................................................
# Description:
#   Create symlink
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://stackoverflow.com/questions/18654162/enable-native-ntfs-symbolic-links-for-cygwin
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

    # optional arguments
    if [ -z ${f+x} ] && [ -z ${d+x} ]; then echo "-d or -f is not defined" & return 1; fi

    # check for empty arguments
    if [ -z ${l+x} ] || [ "${l}" == "" ] || [ "${l}" == "-l" ]; then echo "-l is not defined" & return 1; fi
    if [ -z ${t+x} ] || [ "${t}" == "" ] || [ "${t}" == "-t" ]; then echo "-t is not defined" & return 1; fi

    # file
    if [ ! -z ${f+x} ]; then symlinkFile; fi

    # directory
    if [ ! -z ${d+x} ]; then symlinkDirectory; fi
}

#..................................................................................
# Parse paths to Windows
#
parseWinPaths()
{
    l=$(cygpath --windows --absolute "$l")
    t=$(cygpath --windows --absolute "$t")
}

#..................................................................................
# Create File Symbolic Link
#
symlinkFile()
{
    if [[ "$(slb-ostype.sh)" == "WINDOWS" ]]; then
        parseWinPaths
        CMD //c MKLINK "$l" "$t"
    else
        ln -s "$t" "$l"
    fi
}

#..................................................................................
# Create Directory Symbolic Link
#
symlinkDirectory()
{
    if [[ "$(slb-ostype.sh)" == "WINDOWS" ]]; then
        parseWinPaths
        CMD //c MKLINK "/D" "$l" "$t"
    else
        ln -s "$t" "$l"
    fi
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Create symlink
#/
#/ slb-symlnk.sh [-d] [-f] <-l:> <-t:> [-v] [/?]
#/   -d         Directory Symbolic Link
#/   -f         File Symbolic Link
#/   -l:        Link path
#/   -t:        Target path
#/   -v         Shows the script version
#/   /?         Shows this help