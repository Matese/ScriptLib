#!/bin/sh
#slb-git-scf-net-smbase.sh Version 0.1
#..................................................................................
# Description:
#   Create submodule structure for .NET
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
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

    # check for empty arguments
    if [ -z ${d+x} ] || [ "${d}" == "" ] || [ "${d}" == "-d" ]; then d=$PWD; fi
    if [ -z ${n+x} ] || [ "${n}" == "" ] || [ "${n}" == "-n" ]; then echo "-n is not defined" & return 1; fi

    # generate structure
    scaffold "$d/$n"
}

#..................................................................................
# Generate submodule structure
#
scaffold()
{
    root=$1
    core=$2
    genSm $root
    genReadme $root
    slb-git-scf-net-licnse.sh -d:"$root"
}

#..................................................................................
# Create submodule structure for .NET
#
genSm()
{
    mkdir -p "$1"
    mkdir -p "$1/docs" && >"$1/docs/.gitkeep"
    mkdir -p "$1/lib" && >"$1/lib/.gitkeep"
    mkdir -p "$1/src" && >"$1/src/.gitkeep"
    mkdir -p "$1/tests" && >"$1/tests/.gitkeep"
}

#..................................................................................
# Generate 'README' file content
#
genReadme()
{
    f="$1/README.md"
    >$f
    echo "Submodule structure for .NET" >> $f
    echo "" >> $f
    echo "/" >> $f
    echo "  docs/                 - Documentation (markdown, help, etc.)" >> $f
    echo "  lib/                  - Libraries" >> $f
    echo "  src/                  - Source code" >> $f
    echo "  tests/                - Test projects" >> $f
    echo "  LICENSE               - License" >> $f
    echo "  README.md             - Readme" >> $f
    echo "" >> $f
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Create superproject structure for .NET
#/
#/ slb-git-scf-net-smbase.sh <-d:> <-n:> <-c:> [-v] [/?]
#/   -d         Directory
#/   -n         Name
#/   -c         Core name
#/   -v         Shows the script version
#/   /?         Shows this help