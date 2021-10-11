#!/bin/sh
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
    # default help
    . slb-helper.sh && return 0

    # parse the arguments
    . slb-argadd.sh "$@"

    # check for empty arguments
    if [ -z ${d+x} ] || [ "${d}" == "" ] || [ "${d}" == "-d" ]; then d=$PWD; fi
    if [ -z ${n+x} ] || [ "${n}" == "" ] || [ "${n}" == "-n" ]; then echo "-n is not defined" & return 1; fi
    if [ -z ${c+x} ] || [ "${c}" == "" ] || [ "${c}" == "-c" ]; then echo "-c is not defined" & return 1; fi

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
    genSp $root $core
    genSolution $root $n
    genReadme $root
    slb-git-scf-net-licnse.sh -d:"$root"
}

#..................................................................................
# Create superproject structure for .NET
#
genSp()
{
    mkdir -p "$1"
    mkdir -p "$1/artifacts" && >"$1/artifacts/.gitkeep"
    mkdir -p "$1/packages" && >"$1/packages/.gitkeep"
    >"$1/.root" && echo $2 >> "$1/.root"
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
    >$f
    echo "" >> $f
    echo "Microsoft Visual Studio Solution File, Format Version 12.00" >> $f
    echo "# Visual Studio Version 16" >> $f
    echo "VisualStudioVersion = 16.0.31727.386" >> $f
    echo "MinimumVisualStudioVersion = 10.0.40219.1" >> $f
    echo "Global" >> $f
    echo "	GlobalSection(SolutionProperties) = preSolution" >> $f
    echo "		HideSolutionNode = FALSE" >> $f
    echo "	EndGlobalSection" >> $f
    echo "	GlobalSection(ExtensibilityGlobals) = postSolution" >> $f
    echo "		SolutionGuid = {$uuid}" >> $f
    echo "	EndGlobalSection" >> $f
    echo "EndGlobal" >> $f
}

#..................................................................................
# Generate 'README' file content
#
genReadme()
{
    f="$1/README.md"
    >$f
    echo "Superproject structure for .NET" >> $f
    echo "" >> $f
    echo "/" >> $f
    echo "  artifacts/            - Build outputs (nupkgs, dlls, pdbs, etc.)" >> $f
    echo "  packages/             - Packages (nuget, etc)" >> $f
    echo "  modules/              - Git submodules" >> $f
    echo "  .gitattributes        - https://git-scm.com/docs/gitattributes" >> $f
    echo "  .gitignore            - https://git-scm.com/docs/gitignore" >> $f
    echo "  .gitmodules           - https://git-scm.com/docs/gitmodules" >> $f
    echo "  .root                 - Trick to find root directory" >> $f
    echo "  .runsettings          - Unit tests configurations" >> $f
    echo "  Directory.Build.props - Build customizations" >> $f
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
#/ slb-git-scf-net-spbase.sh <-d:> <-n:> <-c:> [-v] [/?]
#/   -d         Directory
#/   -n         Name
#/   -c         Core name
#/   -v         Shows the script version
#/   /?         Shows this help