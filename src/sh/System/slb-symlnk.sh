#!/bin/sh
#slb-symlnk.sh Version 0.1
#..................................................................................
# Description:
#   Create NTFS (Windows) links that is usable by Windows and Cygwin
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

    # # optional arguments
    if [ -z ${f+x} ] && [ -z ${d+x} ]; then echo "-d or -f is not defined" & return 1; fi

    # # check for empty arguments
    if [ -z ${l+x} ] || [ "${l}" == "" ] || [ "${n}" == "-l" ]; then echo "-l is not defined" & return 1; fi
    if [ -z ${t+x} ] || [ "${t}" == "" ] || [ "${t}" == "-t" ]; then echo "-t is not defined" & return 1; fi

    # parse paths to Windows
    parsePaths

    # file
    if [ ! -z ${f+x} ]; then symlinkFile; fi

    # directory
    if [ ! -z ${d+x} ]; then symlinkDirectory; fi
}

#..................................................................................
# Parse paths to Windows
#
parsePaths()
{
    link_path=$(cygpath --windows --absolute "$l")
    target_path=$(cygpath --windows --absolute "$t")
}

#..................................................................................
# Create File Symbolic Link
#
symlinkFile()
{
    cmd //c mklink "$link_path" "$target_path"
}

#..................................................................................
# Create Directory Symbolic Link
#
symlinkDirectory()
{
    echo "dir"
    cmd //c mklink "/D" "$link_path" "$target_path"
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Create NTFS (Windows) links that is usable by Windows and Cygwin
#/
#/ slb-symlnk.sh [-d] [-f] <-l:> <-t:> [-v] [/?]
#/   -d         Directory Symbolic Link
#/   -f         File Symbolic Link
#/   -l:        Link path
#/   -t:        Target path
#/   -v         Shows the script version
#/   /?         Shows this help