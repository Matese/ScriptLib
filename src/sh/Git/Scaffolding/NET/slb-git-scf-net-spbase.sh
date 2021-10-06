#!/bin/sh
#slb-git-scf-net-spbase.sh Version 0.1
#..................................................................................
# Description:
#   TODO.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://askubuntu.com/questions/474556/hiding-output-of-a-command
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

    # check for empty arguments
    if [ -z ${n+x} ] || [ "${n}" == "" ] || [ "${n}" == "-n" ]; then echo "-n is not defined" & return 1; fi

    # generate structure
    scaffold "$d/$n"
}

#..................................................................................
# Generate superproject structure
#
scaffold()
{
    mkdir -p "$1"
    cd "$1"
    genSp "$PWD"
}

#..................................................................................
# Create superproject structure for .NET
#
genSp()
{
    mkdir -p "$1/artifacts" && >"$1/artifacts/.gitkeep"
    mkdir -p "$1" && >"$1/.root"
    slb-net-scfdng-licnse.sh -d:"$1"
    mkdir -p "$1" && >"$1/README.md" && genReadme "$1/README.md"
    slb-symlnk.sh -f -l:"$1/.runsettings" -t:"$1/modules/core/src/MSBuild/.runsettings"
    slb-symlnk.sh -f -l:"$1/.gitignore" -t:"$1/modules/core/src/Git/.gitignore"
    slb-symlnk.sh -f -l:"$1/.gitattributes" -t:"$1/modules/core/src/Git/.gitattributes"
    slb-symlnk.sh -f -l:"$1/Directory.Build.props" -t:"$1/modules/core/src/MSBuild/Directory.Build.props"

    git init
    git add .
    git commit -m "superproject created"

    # git submodule add http://tfs.larnet:8080/tfs/DESENVOLVIMENTO/LARGIT/_git/core modules/core
    # git submodule add http://tfs.larnet:8080/tfs/DESENVOLVIMENTO/LARGIT/_git/<submodulo> modules/<submodulo>

    # Efeturar o **_commit_** e o **_push_** das alterações em cada repositório.
}

#..................................................................................
# Generate 'README' file content
#
genReadme()
{
    echo "Superproject structure for .NET" >> $1
    echo "" >> $1
    echo "/" >> $1
    echo "  artifacts/            - Build outputs (nupkgs, dlls, pdbs, etc.)" >> $1
    echo "  modules/              - Git submodules" >> $1
    echo "  .gitattributes        - https://git-scm.com/docs/gitattributes" >> $1
    echo "  .gitignore            - https://git-scm.com/docs/gitignore" >> $1
    echo "  .gitmodules           - https://git-scm.com/docs/gitmodules" >> $1
    echo "  .root                 - Trick to find root directory" >> $1
    echo "  .runsettings          - Unit tests configurations" >> $1
    echo "  Directory.Build.props - Build customizations" >> $1
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
#/ slb-git-scf-net-spbase.sh [-v] [/?]
#/   -v         Shows the script version
#/   /?         Shows this help