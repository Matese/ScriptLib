#!/bin/bash
#slb-git-scf-net-spbase.sh Version 0.1
#..................................................................................
# Description:
#   Create superproject structure for .NET
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
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
    if unvalued "d" $f >/dev/null; then d=$PWD; fi

    # shellcheck disable=SC2154,SC2086
    if unvalued "n" $n; then return 1; fi

    # shellcheck disable=SC2154,SC2086
    if unvalued "c" $c; then return 1; fi

    # generate structure
    scaffold "$d/$n" "${c}"
}

#..................................................................................
# Generate superproject structure
#
scaffold()
{
    root=$1
    core=$2
    genSp "$root" "$core"
    genSolution "$root" "$n"
    genReadme "$root"
    slb-git-scf-net-licnse.sh -d:"$root"
}

#..................................................................................
# Create superproject structure for .NET
#
genSp()
{
    mkdir -p "$1"
    mkdir -p "$1/artifacts" && :>"$1/artifacts/.gitkeep"
    mkdir -p "$1/packages" && :>"$1/packages/.gitkeep"
    :>"$1/.root" && echo "$2" >> "$1/.root"
    slb-symlnk.sh -f -l:"$1/.runsettings" -t:"$1/modules/$2/src/MSBuild/.runsettings" > /dev/null 2>&1
    slb-symlnk.sh -f -l:"$1/.gitignore" -t:"$1/modules/$2/src/Git/.gitignore" > /dev/null 2>&1
    slb-symlnk.sh -f -l:"$1/.gitattributes" -t:"$1/modules/$2/src/Git/.gitattributes" > /dev/null 2>&1
    slb-symlnk.sh -f -l:"$1/Directory.Build.props" -t:"$1/modules/$2/src/MSBuild/Directory.Build.props" > /dev/null 2>&1
}

#..................................................................................
# Generate 'Solution' file content
#
genSolution()
{
    uuid=$(slb-uuider.sh)
    f="$1/$2.sln"
    :>"$f"

    {
        echo ""
        echo "Microsoft Visual Studio Solution File, Format Version 12.00"
        echo "# Visual Studio Version 16"
        echo "VisualStudioVersion = 16.0.31727.386"
        echo "MinimumVisualStudioVersion = 10.0.40219.1"
        echo "Global"
        echo "	GlobalSection(SolutionProperties) = preSolution"
        echo "		HideSolutionNode = FALSE"
        echo "	EndGlobalSection"
        echo "	GlobalSection(ExtensibilityGlobals) = postSolution"
        echo "		SolutionGuid = {$uuid}"
        echo "	EndGlobalSection"
        echo "EndGlobal"
    } >> "$f"
}

#..................................................................................
# Generate 'README' file content
#
genReadme()
{
    f="$1/README.md"
    :>"$f"

    {
        echo "Superproject structure for .NET"
        echo ""
        echo "/"
        echo "  artifacts/            - Build outputs (nupkgs, dlls, pdbs, etc.)"
        echo "  packages/             - Packages (nuget, etc)"
        echo "  modules/              - Git submodules"
        echo "  .gitattributes        - https://git-scm.com/docs/gitattributes"
        echo "  .gitignore            - https://git-scm.com/docs/gitignore"
        echo "  .gitmodules           - https://git-scm.com/docs/gitmodules"
        echo "  .root                 - Trick to find root directory"
        echo "  .runsettings          - Unit tests configurations"
        echo "  Directory.Build.props - Build customizations"
        echo "  LICENSE               - License"
        echo "  README.md             - Readme"
        echo ""
    } >> "$f"
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
#/ Create superproject structure for .NET
#/
#/ slb-git-scf-net-spbase.sh <-d:> <-n:> <-c:> [-v] [/?]
#/   -d         Directory
#/   -n         Name
#/   -c         Core name
#/   -v         Shows the script version
#/   /?         Shows this help