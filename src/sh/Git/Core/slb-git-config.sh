#!/bin/bash
#slb-git-config.sh Version 0.1
#..................................................................................
# Description:
#   Create git configurations.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://github.com/koalaman/shellcheck
#..................................................................................

#..................................................................................
# The main entry point for the script
#
main()
{
    # shellcheck source=/dev/null
    # default help
    . slb-helper.sh && return 0

    # shellcheck source=/dev/null
    # parse the arguments
    . slb-argadd.sh "$@"

    # # check for empty arguments
    if [ -z ${n+x} ] || [ "${n}" == "" ] || [ "${n}" == "-n" ]; then echo "-n is not defined" & return 1; fi
    if [ -z ${e+x} ] || [ "${e}" == "" ] || [ "${e}" == "-e" ]; then echo "-e is not defined" & return 1; fi

    # create .gitconfig file name
    gitconfig=$HOME/.gitconfig

    # delete old .gitconfig file if exists
    if [ -f "$gitconfig" ]; then rm "$gitconfig"; fi

    # create new .gitconfig file
    touch "$gitconfig"

    # write content to .gitconfig file
    {
        echo "[core]"
        echo "	symlinks = true"
        echo "[user]"
        echo "	name = $n"
        echo "	email = $e"
        echo "[alias]"
        echo "	puller = $PWD/slb-git-puller.sh"
        echo "	getter = $PWD/slb-git-getter.sh"
        echo "	lister = $PWD/slb-git-lister.sh"
        echo "	sender = $PWD/slb-git-sender.sh"
        echo "	updter = $PWD/slb-git-updter.sh"
        echo "	checkr = $PWD/slb-git-checkr.sh"
        echo "	stater = $PWD/slb-git-stater.sh"
        echo "	guider = $PWD/slb-git-guider.sh"
    } >> "$gitconfig"
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Create git configurations.
#/
#/ slb-git-config <-n:> <-e:> [-v] [/?]
#/   -n:       The name of the user
#/   -e:       The email of the user
#/   -v        Shows the batch version
#/   /?        Help
#/
#/ Sample:
#/    slb-git-config -n:"Juca Pirama" -e:jucapirama@bixao.com.br