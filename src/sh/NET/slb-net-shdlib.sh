#!/bin/sh
#slb-net-shdlib.sh Version 0.1
#..................................................................................
# Description:
#   TODO.
#
# History:
#   - v0.1 2021-09-23 Initial release including basic documentation
#
# Remarks:
#   Inspired by
#     -> todo
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

    create $d
}

#..................................................................................
#
#
create()
{
    root=$1

    mkdir -p "$root"
    mkdir -p "$root/src"
            >"$root/src/.gitkeep"
    mkdir -p "$root/src/Git"
            >"$root/src/Git/.gitkeep"
    mkdir -p "$root/src/MSBuild"
            >"$root/src/MSBuild/.gitkeep"
            >"$root/src/MSBuild/.runsettings"
            >"$root/src/MSBuild/Common.props"
            >"$root/src/MSBuild/Configurations.Platforms.props"
            >"$root/src/MSBuild/Directory.Build.props"
            >"$root/src/MSBuild/Resources.props"
            >"$root/src/MSBuild/Settings.props"
            >"$root/src/MSBuild/Targets.props"
    mkdir -p "$root/src/MSBuild/Projects"
            >"$root/src/MSBuild/Projects/.gitkeep"
    mkdir -p "$root/src/MSBuild/References"
            >"$root/src/MSBuild/References/.gitkeep"
    mkdir -p "$root/src/NuGet"
            >"$root/src/NuGet/.gitkeep"
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
#/ slb-net-shdlib.sh [-v] [/?]
#/   -v         Shows the script version
#/   /?         Shows this help
#/