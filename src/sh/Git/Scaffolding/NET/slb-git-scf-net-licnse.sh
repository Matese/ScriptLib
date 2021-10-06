#!/bin/sh
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
# Generate structure
#
scaffold()
{
    mkdir -p "$1"
    mkdir -p "$1" && >"$1/LICENSE" && genLicence "$1/LICENSE"
}

#..................................................................................
# Generate license
#
genLicence()
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