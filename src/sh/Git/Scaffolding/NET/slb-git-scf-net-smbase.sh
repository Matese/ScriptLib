#!/bin/sh
#slb-git-scf-net-smbase.sh Version 0.1
#..................................................................................
# Description:
#   TODO.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> todo
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

    # default arguments
    if [ -z ${d+x} ] || [ "${d}" == "" ] || [ "${d}" == "-d" ]; then d=$PWD; fi

    # generate structure
    scaffold $d
}

#..................................................................................
# Generate submodule structure
#
scaffold()
{
    mkdir -p "$1"
    mkdir -p "$1/src"

    genGit $1
    genMsbuild $1
}

#..................................................................................
# Create  structure for .NET
#
dotnetsm()
{
    root=$d/$n
    common=${root%/*/*}/core/src/Common

    mkdir -p "$root"
    mkdir -p "$root/artifacts" && >"$root/artifacts/.gitkeep"
    mkdir -p "$root/docs" && >"$root/docs/.gitkeep"
    mkdir -p "$root/lib" && >"$root/lib/.gitkeep"
    mkdir -p "$root/packages" && >"$root/packages/.gitkeep"
    mkdir -p "$root/src" && >"$root/src/.gitkeep"
    mkdir -p "$root/tests" && >"$root/tests/.gitkeep"
    slb-net-scfdng-licnse.sh -d:"$root"
    mkdir -p "$root" && >"$root/README.md" && genReadme "$root/README.md"

    slb-symlnk.sh -f -l:"$root/.gitignore" -t:"$common/.gitignore"
    slb-symlnk.sh -f -l:"$root/.gitattributes" -t:"$common/.gitattributes"
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
#/ TODO
#/
#/ slb-git-scf-net-smbase.sh [-v] [/?]
#/   -v         Shows the script version
#/   /?         Shows this help