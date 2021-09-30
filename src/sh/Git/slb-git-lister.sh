#!/bin/sh
#slb-git-lister.sh Version 0.1
#..................................................................................
# Description:
#   List superprojects and submodules
#
# History:
#   - v0.1 2021-09-23 Initial release including basic documentation
#
# Remarks:
#   Inspired by
#     -> TODO
#

#..................................................................................
# The main entry point for the script
#
main()
{
    if [ -z "$1" ]; then
        curl -s -u todo http://todo/git/repositories?api-version=3.1-preview | jq "[.value[].name | select(. | contains(\"_super\") | not)] - [.value[].name | select(. | contains(\"_super\")) | sub(\"_super\";\"\")] | .[]"
    elif [ "$1" = super ]; then
        curl -s -u todo http://todo/git/repositories?api-version=3.1-preview | jq "[.value[].name | select(. | contains(\"_super\"))] | .[]"
    elif [ "$1" = sub ]; then
        curl -s -u todo http://todo/git/repositories?api-version=3.1-preview | jq "[.value[].name | select(. | contains(\"_super\")) | sub(\"_super\";\"\")] | .[]"
    elif [ "$1" = all ]; then
        curl -s -u todo http://todo/git/repositories?api-version=3.1-preview | jq ".value[].name"
    fi
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
#/ slb-git-lister.sh [-dir:] [-v] [/?]
#/   -dir       Directory of the repository
#/   -v         Shows the script version
#/   /?         Shows this help
#/