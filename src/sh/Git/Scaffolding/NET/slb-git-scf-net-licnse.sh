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
    genLicence $1
}

#..................................................................................
# Generate license
#
genLicence()
{
    f="$1/LICENSE"
    >$f
    echo "MIT License" >> $f
    echo "" >> $f
    echo "Copyright (c) 2021" >> $f
    echo "" >> $f
    echo "Permission is hereby granted, free of charge, to any person obtaining a copy" >> $f
    echo "of this software and associated documentation files (the \"Software\"), to deal" >> $f
    echo "in the Software without restriction, including without limitation the rights" >> $f
    echo "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell" >> $f
    echo "copies of the Software, and to permit persons to whom the Software is" >> $f
    echo "furnished to do so, subject to the following conditions:" >> $f
    echo "" >> $f
    echo "The above copyright notice and this permission notice shall be included in all" >> $f
    echo "copies or substantial portions of the Software." >> $f
    echo "" >> $f
    echo "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR" >> $f
    echo "IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY," >> $f
    echo "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE" >> $f
    echo "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER" >> $f
    echo "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM," >> $f
    echo "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE" >> $f
    echo "SOFTWARE." >> $f
    echo "" >> $f
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