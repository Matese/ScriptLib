#!/bin/bash
#slb-git-scf-net-licnse.sh Version 0.1
#..................................................................................
# Description:
#   Generate the license file.
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

    # generate structure
    scaffold "$d"
}

#..................................................................................
# Generate structure
#
scaffold()
{
    genLicence "$1"
}

#..................................................................................
# Generate license
#
genLicence()
{
    f="$1/LICENSE"
    :>"$f"

    {
        echo "MIT License"
        echo ""
        echo "Copyright (c) 2021"
        echo ""
        echo "Permission is hereby granted, free of charge, to any person obtaining a copy"
        echo "of this software and associated documentation files (the \"Software\"), to deal"
        echo "in the Software without restriction, including without limitation the rights"
        echo "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell"
        echo "copies of the Software, and to permit persons to whom the Software is"
        echo "furnished to do so, subject to the following conditions:"
        echo ""
        echo "The above copyright notice and this permission notice shall be included in all"
        echo "copies or substantial portions of the Software."
        echo ""
        echo "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR"
        echo "IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,"
        echo "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE"
        echo "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER"
        echo "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,"
        echo "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE"
        echo "SOFTWARE."
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
#/ Generate the license file.
#/
#/ slb-git-scf-net-licnse.sh [-d:] [-v] [/?]
#/   -d:        Directory
#/   -v         Shows the script version
#/   /?         Shows this help