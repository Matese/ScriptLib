#!/bin/sh
#slb-scfdng.sh Version 0.1
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

    # default arguments
    if [ -z ${d+x} ] || [ "${d}" == "" ] || [ "${d}" == "-d" ]; then d=$PWD; fi

    # check for empty arguments
    if [ -z ${n+x} ] || [ "${n}" == "" ] || [ "${n}" == "-n" ]; then echo "-n is not defined" & return 1; fi

    # .NET superproject
    if [ ! -z ${dotnetsp+x} ]; then dotnetsp; fi

    # .NET submodule
    if [ ! -z ${dotnetsm+x} ]; then dotnetsm; fi

    # .NET
    if [ ! -z ${shdlib+x} ]; then slb-net-shdlib "$d/$n"; fi
}

#..................................................................................
# Create superproject structure for .NET
#
dotnetsp()
{
    root=$d/$n
    common=$root/modules/core/src/Common

    mkdir -p "$root"
    mkdir -p "$root/artifacts" && >"$root/artifacts/.gitkeep"
    mkdir -p "$root/modules" && >"$root/modules/.gitkeep"
    mkdir -p "$root" && >"$root/.gitmodules"
    mkdir -p "$root" && >"$root/.root"
    mkdir -p "$root" && >"$root/LICENSE" && licence "$root/LICENSE"
    mkdir -p "$root" && >"$root/README.md" && readme "$root/README.md"

    slb-symlnk.sh -f -l:"$root/.runsettings" -t:"$common/.runsettings"
    slb-symlnk.sh -f -l:"$root/.gitignore" -t:"$common/.gitignore"
    slb-symlnk.sh -f -l:"$root/.gitattributes" -t:"$common/.gitattributes"
    slb-symlnk.sh -f -l:"$root/Directory.Build.props" -t:"$common/Directory.Build.props"

    # git submodule add http://tfs.larnet:8080/tfs/DESENVOLVIMENTO/LARGIT/_git/core modules/core
    # git submodule add http://tfs.larnet:8080/tfs/DESENVOLVIMENTO/LARGIT/_git/<submodulo> modules/<submodulo>

    # Efeturar o **_commit_** e o **_push_** das alterações em cada repositório.

}

#..................................................................................
# Create submodule structure for .NET
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
    mkdir -p "$root" && >"$root/LICENSE" && licence "$root/LICENSE"
    mkdir -p "$root" && >"$root/README.md" && readme "$root/README.md"

    slb-symlnk.sh -f -l:"$root/.gitignore" -t:"$common/.gitignore"
    slb-symlnk.sh -f -l:"$root/.gitattributes" -t:"$common/.gitattributes"
}

#..................................................................................
# TODO
#
licence()
{
    echo "MIT License" >> $1
    echo "" >> $1
    echo "Copyright (c) 2021" >> $1
    echo "" >> $1
    echo "Permission is hereby granted, free of charge, to any person obtaining a copy" >> $1
    echo "of this software and associated documentation files (the \"Software\"), to deal" >> $1
    echo "in the Software without restriction, including without limitation the rights" >> $1
    echo "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell" >> $1
    echo "copies of the Software, and to permit persons to whom the Software is" >> $1
    echo "furnished to do so, subject to the following conditions:" >> $1
    echo "" >> $1
    echo "The above copyright notice and this permission notice shall be included in all" >> $1
    echo "copies or substantial portions of the Software." >> $1
    echo "" >> $1
    echo "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR" >> $1
    echo "IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY," >> $1
    echo "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE" >> $1
    echo "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER" >> $1
    echo "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM," >> $1
    echo "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE" >> $1
    echo "SOFTWARE." >> $1
    echo "" >> $1
}

#..................................................................................
# TODO
#
readme()
{
    echo "TODO" >> $1
    echo "" >> $1
    echo "DEFINE THE STRUCTURE" >> $1
    echo "" >> $1
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
#/ slb-scfdng.sh <-n:> [-d:] [-dotnetsp] [-dotnetsm] [-v] [/?]
#/   -n:        Project name
#/   -d:        Directory
#/   -dotnetsp  Superproject structure for .NET
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
#/   -dotnetsm  Submodule structure for .NET
#/                <-n>/
#/                  artifacts/            - Build outputs (nupkgs, dlls, pdbs, etc.)
#/                  docs/                 - Documentation (markdown, help, etc.)
#/                  lib/                  - Libraries
#/                  packages/             - Packages (nuget, etc)
#/                  src/                  - Source code
#/                  tests/                - Test projects
#/                  LICENSE               - License
#/                  README.md             - Readme
#/   -v         Shows the script version
#/   /?         Shows this help