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
    if [ -z ${c+x} ] || [ "${c}" == "" ] || [ "${c}" == "-c" ]; then echo "-c is not defined" & return 1; fi

    # generate structure
    scaffold "$d/$n" "$c"
}

#..................................................................................
# Generate submodule structure
#
scaffold()
{
    root=$1
    core=$2
    genSm $root $core
    genReadme $root
    slb-git-scf-net-licnse.sh -d:"$root"
}

#..................................................................................
# Create submodule structure for .NET
#
genSm()
{
    mkdir -p "$1"
    mkdir -p "$1/artifacts" && >"$1/artifacts/.gitkeep"
    mkdir -p "$1/docs" && >"$1/docs/.gitkeep"
    mkdir -p "$1/lib" && >"$1/lib/.gitkeep"
    mkdir -p "$1/packages" && >"$1/packages/.gitkeep"
    mkdir -p "$1/src" && >"$1/src/.gitkeep"
    mkdir -p "$1/tests" && >"$1/tests/.gitkeep"

    git=${1%/*/*}/$2/src/Git
    slb-symlnk.sh -f -l:"$1/.gitignore" -t:"$git/.gitignore"
    slb-symlnk.sh -f -l:"$1/.gitattributes" -t:"$git/.gitattributes"
}

#..................................................................................
# Generate 'README' file content
#
genReadme()
{
    echo "Submodule structure for .NET" >> $1
    echo "" >> $1
    echo "/" >> $1
    echo "  artifacts/            - Build outputs (nupkgs, dlls, pdbs, etc.)" >> $1
    echo "  docs/                 - Documentation (markdown, help, etc.)" >> $1
    echo "  lib/                  - Libraries" >> $1
    echo "  packages/             - Packages (nuget, etc)" >> $1
    echo "  src/                  - Source code" >> $1
    echo "  tests/                - Test projects" >> $1
    echo "  LICENSE               - License" >> $1
    echo "  README.md             - Readme" >> $1
    echo "" >> $1
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