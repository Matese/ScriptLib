#!/bin/bash
#slb-git-scf-net-genspm.sh Version 0.1
#..................................................................................
# Description:
#   Create superproject/submodule structure for .NET
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://askubuntu.com/questions/474556/hiding-output-of-a-command
#     -> https://unix.stackexchange.com/questions/462701/how-to-get-the-current-path-without-last-folder-in-a-script
#     -> https://stackoverflow.com/questions/7632454/how-do-you-use-git-bare-init-repository
#     -> https://unix.stackexchange.com/questions/45676/how-do-i-remove-a-directory-and-all-its-contents
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
    if unvalued "sd" $sd; then return 1; fi
    if unvalued "su" $su; then return 1; fi
    if unvalued "sn" $sn; then return 1; fi
    }

    # shellcheck disable=SC2154,SC2086
    if defined $md && defined $mu && defined $mn; then

        if unvalued "md" $md; then return 1; fi
        if unvalued "mu" $mu; then return 1; fi
        if unvalued "mn" $mn; then return 1; fi

        isCore=false

    elif defined $cd && defined $cu && defined $cn; then

        if unvalued "cd" $cd; then return 1; fi
        if unvalued "cu" $cu; then return 1; fi
        if unvalued "cn" $cn; then return 1; fi

        isCore=true
    else
        echo "module not defined" & return 1;
    fi

    # generate structure
    scaffold
}

#..................................................................................
# Generate structure
#
scaffold()
{
    # check if upstream ends with a /
    if [[ ! $su == */ ]]; then su=$su/; fi
    if [[ ! $mu == */ ]]; then mu=$mu/; fi
    if [[ ! $cu == */ ]]; then cu=$cu/; fi

    superExists="$(slb-git-exists.sh -url:"$su$sn.git")"
    coreExists="$(slb-git-exists.sh -url:"$cu$cn.git")"
    subExists="$(slb-git-exists.sh -url:"$mu$mn.git")"

    if [ "$superExists" == true ]; then
        if [ $isCore == true ]; then
            echo "Cannot create a Core Submodule in a Superproject that already contains one!"
        else
            if [ "$subExists" == true ]; then
                addSubInSuper "$mn" "$sn"
            else
                checkBare "$mu" "$mn"
                genSubInSuper "$mn" "$sn"
            fi
        fi
    else
        if [ $isCore == true ]; then
            checkBare "$su" "$sn"
            checkBare "$cu" "$cn"
            if [ "$coreExists" == true ]; then
                genSuperAddCore "$sn" "$cn"
            else
                genSuperGenCore "$sn" "$cn"
            fi
        else
            echo "Cannot create a Superproject without Core Submodule!"
        fi
    fi
}

#..................................................................................
# Check if need to initalize a local bare repository
#
checkBare()
{
    u=$1 # upstream
    n=$2 # name

    # regex to check if a URL valid
    regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'

    # check if is not a valid link
    if [[ ! $u =~ $regex ]]; then
        # check if directory do not exist
        if [ ! -d "$u$n.git" ]; then
            # initialize a bare local repo
            git init --bare "$u$n.git"
        fi
    fi
}

#..................................................................................
# Generate submodule in superproject
#
genSubInSuper()
{
    # clone supermodule if needed
    if [ ! -d "$sd/$sn" ]; then
        git clone "$su$sn" "$sd/$sn" > /dev/null 2>&1
    fi

    # get core name from superproject
    cn=$(head -n 1 "$sd/$sn/.root")

    # create temp dir
    td=$(mktemp -d)

    # create submodule
    git clone "$mu$mn" "$td/$mn" > /dev/null 2>&1
    cd "$td/$mn" || exit
    slb-git-scf-net-smbase.sh -d:"$td" -n:"$mn"
    slb-symlnk.sh -f -l:"$td/$mn/.gitignore" -t:"$sd/$sn/modules/$cn/src/Git/.gitignore"  > /dev/null 2>&1
    slb-symlnk.sh -f -l:"$td/$mn/.gitattributes" -t:"$sd/$sn/modules/$cn/src/Git/.gitattributes"  > /dev/null 2>&1
    git add . > /dev/null 2>&1
    git commit -m "submodule $mn created" > /dev/null 2>&1
    git push -u origin master > /dev/null 2>&1

    # add submodule to superproject
    cd "$sd/$sn" || exit
    git submodule add "$mu$mn" "modules/$mn" > /dev/null 2>&1
    git add . > /dev/null 2>&1
    git commit -m "submodule $mn added to superproject $sn" > /dev/null 2>&1
    git push -u origin master > /dev/null 2>&1

    # delete temp dir
    rm -rf "$td"

    echo "Created Submodule '$1' in Superproject '$2'"
}

#..................................................................................
# Add submodule in superproject
#
addSubInSuper()
{
    echo "TODO: addSubInSuper"
    # echo "Added Submodule '$1' in Superproject '$2'"
}

#..................................................................................
# Generate superproject and core
#
genSuperGenCore()
{
    # create temp dir
    td=$(mktemp -d)

    # create core submodule
    git clone "$cu$cn" "$td/$cn" > /dev/null 2>&1
    cd "$td/$cn" || exit
    slb-git-scf-net-smcore.sh -d:"$td" -n:"$cn"
    git add . > /dev/null 2>&1
    git commit -m "submodule $cn created" > /dev/null 2>&1
    git push -u origin master > /dev/null 2>&1

    # create superproject adding core submodule
    git clone "$su$sn" "$sd/$sn" > /dev/null 2>&1
    cd "$sd/$sn" || exit
    slb-git-scf-net-spbase.sh -d:"$sd" -n:"$sn" -c:"$cn"
    git add . > /dev/null 2>&1
    git commit -m "superproject $sn created" > /dev/null 2>&1
    git submodule add "$cu$cn" "modules/$cn" > /dev/null 2>&1
    git add . > /dev/null 2>&1
    git commit -m "submodule $cn added to superproject $sn" > /dev/null 2>&1
    git push -u origin master > /dev/null 2>&1

    # delete temp dir
    rm -rf "$td"

    echo "Created Superproject '$1' and Core Submodule '$2'"
}

#..................................................................................
# Generate superproject adding existent core
#
genSuperAddCore()
{
     # create superproject adding core submodule
    git clone "$su$sn" "$sd/$sn" > /dev/null 2>&1
    cd "$sd/$sn" || exit
    slb-git-scf-net-spbase.sh -d:"$sd" -n:"$sn" -c:"$cn"
    git add . > /dev/null 2>&1
    git commit -m "superproject $sn created" > /dev/null 2>&1
    git submodule add "$cu$cn" "modules/$cn" > /dev/null 2>&1
    git add . > /dev/null 2>&1
    git commit -m "submodule $cn added to superproject $sn" > /dev/null 2>&1
    git push -u origin master > /dev/null 2>&1

    echo "Created Superproject '$1' adding existent Core Submodule '$2'"
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
# Check if variable is defined
#
defined()
{
    # if variable is unset or set to the empty string
    if [ -z ${1+x} ]; then
        return 1 # false
    fi

    return 0 # true
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Create superproject/submodule structure for .NET
#/
#/ slb-git-scf-net-genspm.sh <-sd:> <-su:> <-sn:> <-md:> <-mu:> <-mn:> <-cd:>
#/ <-cu:> <-cn:> [-v] [/?]
#/   -sd:       Superproject directory
#/   -su:       Superproject upstream
#/   -sn:       Superproject name
#/   -md:       Submodule directory
#/   -mu:       Submodule upstream
#/   -mn:       Submodule name
#/   -cd:       Core submodule directory
#/   -cu:       Core submodule upstream
#/   -cn:       Core submodule name
#/   -v         Shows the script version
#/   /?         Shows this help