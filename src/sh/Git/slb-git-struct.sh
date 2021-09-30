#!/bin/sh
#slb-git-struct.sh Version 0.1
#..................................................................................
# Description:
#   todo
#
# History:
#   - v0.1 2021-09-23 Initial release including basic documentation
#
# Remarks:
#   Inspired by
#     -> https://stackoverflow.com/questions/3790101/bash-script-regex-to-get-directory-path-up-nth-levels
#

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
    if [ -z ${d+x} ] || [ "${d}" == "" ] || [ "${d}" == "-d" ]; then d=$PWD; fi
    if [ -z ${sp+x} ] && [ -z ${sm+x} ]; then echo "-sp or -sm is not defined" & return 1; fi

    # check for empty arguments
    if [ -z ${n+x} ] || [ "${n}" == "" ] || [ "${n}" == "-n" ]; then echo "-n is not defined" & return 1; fi

    # superproject
    if [ ! -z ${sp+x} ]; then superproject; fi

    # submodule
    if [ ! -z ${sm+x} ]; then submodule; fi
}

#..................................................................................
# Create a superproject structure
#
superproject()
{
    root=$d/$n
    common=$root/modules/core/src/Common

    mkdir -p "$root"
    mkdir -p "$root/artifacts" && >"$root/artifacts/.gitkeep"
    mkdir -p "$root/modules" && >"$root/modules/.gitkeep"
    mkdir -p "$root" && >"$root/.gitmodules"
    mkdir -p "$root" && >"$root/.root"
    mkdir -p "$root" && >"$root/LICENSE"
    mkdir -p "$root" && >"$root/README.md"

    slb-git-symlnk.sh -f -l:"$root/.runsettings" -t:"$common/.runsettings"
    slb-git-symlnk.sh -f -l:"$root/.gitignore" -t:"$common/.gitignore"
    slb-git-symlnk.sh -f -l:"$root/.gitattributes" -t:"$common/.gitattributes"
    slb-git-symlnk.sh -f -l:"$root/Directory.Build.props" -t:"$common/Directory.Build.props"
}

#..................................................................................
# Create a submodule structure
#
submodule()
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
    mkdir -p "$root" && >"$root/LICENSE"
    mkdir -p "$root" && >"$root/README.md"

    slb-git-symlnk.sh -f -l:"$root/.gitignore" -t:"$common/.gitignore"
    slb-git-symlnk.sh -f -l:"$root/.gitattributes" -t:"$common/.gitattributes"
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ todo.
#/
#/ slb-git-struct.sh <-n:> [-d:] [-sp] [-sm] [-v] [/?]
#/   -n:        Project name
#/   -d:        Directory
#/   -sp        Superproject
#/                <-n>/
#/                  artifacts/            - Build outputs (nupkgs, dlls, pdbs, etc.)
#/                  modules/              - Git submodules
#/                  .gitattributes        - https://git-scm.com/docs/gitattributes
#/                  .gitignore            - https://git-scm.com/docs/gitignore
#/                  .gitmodules           - https://git-scm.com/docs/gitmodules
#/                  .root                 - Trick to find root directory
#/                  .runsettings          - Unit tests configurations
#/                  Directory.Build.props - Build customizations
#/                  LICENSE               - License
#/                  README.md             - Readme
#/   -sm        Submodule
#/                <-n>/
#/                  artifacts/            - Build outputs (nupkgs, dlls, pdbs, etc.)
#/                  docs/                 - Documentation (markdown, help, etc.)
#/                  lib/                  - Libraries
#/                  packages/             - Packages (nuget, etc)
#/                  src/                  - Source code
#/                  tests/                - Test projects
#/                  LICENSE               - License
#/                  README.md             - Readme
#/
#/   -v         Shows the script version
#/   /?         Shows this help
#/