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
    # shellcheck source=/dev/null
    {
    . slb-helper.sh && return 0
    . slb-argadd.sh "$@"
    }

    # shellcheck disable=SC2154,SC2086
    {
    if undefined "f" $f >/dev/null &&
       undefined "d" $d >/dev/null ; then echo "-f or -d is not defined" & return 1; fi

    if unvalued "l" $l; then return 1; fi
    if unvalued "t" $t; then return 1; fi

    if defined $f; then
        symlinkFile;
        return 0
    fi

    if defined $d; then
        symlinkDirectory;
        return 0
    fi
    }
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
# Check if variable is defined
#
defined()
{
    # if variable is unset or set to the empty string
    if [ -z ${1+x} ]; then
        return 1 # false
    fi

    return 0 # true
}

#..................................................................................
# Check if variable is undefined
#
undefined()
{
    # if variable is unset or set to the empty string
    if [ -z ${2+x} ]; then
        echo "-${1} is not defined"
        return 0 # true
    fi

    return 1 # false
}

#..................................................................................
# Check if variable is empty
#
unvalued()
{
    # if variable is unset or set to the empty string
    if [ -z ${2+x} ]; then
        echo "-${1} is empty"
        return 0 # true
    fi

    # if variable is set to it´s own name
    if [ "${2}" == "-${1}" ]; then
        echo "-${1} is empty"
        return 0 # true
    fi

    return 1 # false
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