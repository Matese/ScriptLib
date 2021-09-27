#!/bin/sh
#slb-argadd.sh Version 0.1
#..................................................................................
# Description:
#   Parse and define args to be used.
#
# History:
#   - v0.1 2021-09-27 Initial release including basic documentation
#
# Remarks:
#   Inspired by
#     -> https://www.brianchildress.co/named-parameters-in-bash/
#     -> https://stackoverflow.com/questions/45921699/bash-substring-from-first-occurrence-of-a-character-to-the-second-occurrence
#     -> https://janbio.home.blog/2020/03/18/remove-all-after-character-or-last-character-in-r
#     -> https://stackoverflow.com/questions/13437104/compare-content-of-two-variables-in-bash
#     -> https://stackoverflow.com/questions/20866832/is-it-possible-to-mimic-process-substitution-on-msys-mingw-with-bash-3-x
#

#..................................................................................
# The main entry point for the script
#
while [ $# -gt 0 ]; do

    if [[ $1 == *"-"* ]]; then
        keytempvar=${1%%:*}           # Remove all after first ":"
        keytempvar="${keytempvar/-/}" # Remove starting dash
        valuetempvar=${1#*:}          # Remove everything up to :
        declare $keytempvar="${valuetempvar}"
    fi

    shift
done

#..................................................................................
#..HELP...
#/
#/ Parse and define args to be used.
#/
#/ slb-argadd.sh Argument<:Value> <<ArgumentN>:<ValueN>> [-v] [/?]
#/   Argument   The name of the argument
#/   Value      The value of the argument (if nothing defined, defaults to 1)
#/   -v         Shows the script version
#/   /?         Shows this help