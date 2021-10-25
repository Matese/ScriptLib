#!/bin/bash
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
    # shellcheck source=/dev/null
    {
    . slb-helper.sh && return 0
    . slb-argadd.sh "$@"
    }

    # shellcheck disable=SC2154,SC2086
    {
    if unvalued "d" $d >/dev/null; then d=$PWD; fi
    if unvalued "n" $n; then return 1; fi
    }

    # generate structure
    scaffold "$d/$n"
}

#..................................................................................
# Generate submodule structure
#
scaffold()
{
    root=$1
    genSm "$root"
    genReadme "$root"
    slb-git-scf-net-licnse.sh -d:"$root"
}

#..................................................................................
# Create submodule structure for .NET
#
genSm()
{
    mkdir -p "$1"
    mkdir -p "$1/docs" && :>"$1/docs/.gitkeep"
    mkdir -p "$1/lib" && :>"$1/lib/.gitkeep"
    mkdir -p "$1/src" && :>"$1/src/.gitkeep"
    mkdir -p "$1/tests" && :>"$1/tests/.gitkeep"
}

#..................................................................................
# Generate 'README' file content
#
genReadme()
{
    f="$1/README.md"
    :>"$f"

    {
        echo "# Submodule structure for .NET"
        echo ""
        echo "\`\`\`text"
        echo "📂"
        echo "┣📂docs                 - Documentation (markdown, help, etc.)"
        echo "┣📂lib                  - Libraries"
        echo "┣📂src                  - Source code"
        echo "┣📂tests                - Test projects"
        echo "┣📜LICENSE              - License"
        echo "┗📜README.md            - Readme"
        echo "\`\`\`"
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
#/ slb-git-scf-net-smbase.sh <-d:> <-n:> <-c:> [-v] [/?]
#/   -d         Directory
#/   -n         Name
#/   -c         Core name
#/   -v         Shows the script version
#/   /?         Shows this help