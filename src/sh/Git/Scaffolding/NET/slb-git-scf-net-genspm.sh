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
    # default help
    . slb-helper.sh && return 0

    # parse the arguments
    . slb-argadd.sh "$@"

    # check all the arguments and the existence of the repositories
    if [ -z ${sd+x} ] || [ "${sd}" == "" ] || [ "${sd}" == "-sd" ]; then echo "-sd is not defined" & return 1; fi
    if [ -z ${su+x} ] || [ "${su}" == "" ] || [ "${su}" == "-su" ]; then echo "-su is not defined" & return 1; fi
    if [ -z ${sn+x} ] || [ "${sn}" == "" ] || [ "${sn}" == "-sn" ]; then echo "-sn is not defined" & return 1; fi
    if [ ! -z ${md+x} ] && [ ! -z ${mu+x} ] && [ ! -z ${mn+x} ]; then
        if [ "${md}" == "" ] || [ "${md}" == "-md" ]; then echo "-md is not defined" & return 1; fi
        if [ "${mu}" == "" ] || [ "${mu}" == "-mu" ]; then echo "-mu is not defined" & return 1; fi
        if [ "${mn}" == "" ] || [ "${mn}" == "-mn" ]; then echo "-mn is not defined" & return 1; fi
        isCore=false
    elif [ ! -z ${cd+x} ] && [ ! -z ${cu+x} ] && [ ! -z ${cn+x} ]; then
        if [ "${cd}" == "" ] || [ "${cd}" == "-cd" ]; then echo "-cd is not defined" & return 1; fi
        if [ "${cu}" == "" ] || [ "${cu}" == "-cu" ]; then echo "-cu is not defined" & return 1; fi
        if [ "${cn}" == "" ] || [ "${cn}" == "-cn" ]; then echo "-cn is not defined" & return 1; fi
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

    if [ $superExists == true ]; then
        if [ $isCore == true ]; then
            echo "Cannot create a Core Submodule in a Superproject that already contains one!"
        else
            if [ $subExists == true ]; then
                addSubInSuper
                echo "Added Submodule '$mn' in Superproject '$sn'"
            else
                checkBare "$mu" "$mn"
                genSubInSuper
                echo "Created Submodule '$mn' in Superproject '$sn'"
            fi
        fi
    else
        if [ $isCore == true ]; then
            checkBare "$su" "$sn"
            checkBare "$cu" "$cn"
            if [ $coreExists == true ]; then
                genSuperAddCore
                echo "Created Superproject '$sn' adding existent Core Submodule '$sn'"
            else
                genSuperGenCore
                echo "Created Superproject '$sn' and Core Submodule '$cn'"
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
            git init --bare $u$n.git
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
        git clone $su$sn $sd/$sn > /dev/null 2>&1
    fi

    # get core name from superproject
    cn=$(head -n 1 $sd/$sn/.root)

    # create temp dir
    td=$(mktemp -d)

    # create submodule
    git clone $mu$mn $td/$mn > /dev/null 2>&1
    cd $td/$mn
    slb-git-scf-net-smbase.sh -d:"$td" -n:"$mn"
    slb-symlnk.sh -f -l:"$td/$mn/.gitignore" -t:"$sd/$sn/modules/$cn/src/Git/.gitignore"  > /dev/null 2>&1
    slb-symlnk.sh -f -l:"$td/$mn/.gitattributes" -t:"$sd/$sn/modules/$cn/src/Git/.gitattributes"  > /dev/null 2>&1
    git add . > /dev/null 2>&1
    git commit -m "submodule $mn created" > /dev/null 2>&1
    git push -u origin master > /dev/null 2>&1

    # add submodule to superproject
    cd $sd/$sn
    git submodule add $mu$mn modules/$mn > /dev/null 2>&1
    git add . > /dev/null 2>&1
    git commit -m "submodule $mn added to superproject $sn" > /dev/null 2>&1
    git push -u origin master > /dev/null 2>&1

    # delete temp dir
    rm -rf $td
}

#..................................................................................
# Add submodule in superproject
#
addSubInSuper()
{
    echo "addSubInSuper"
}

#..................................................................................
# Generate superproject and core
#
genSuperGenCore()
{
    # create temp dir
    td=$(mktemp -d)

    # create core submodule
    git clone $cu$cn $td/$cn > /dev/null 2>&1
    cd $td/$cn
    slb-git-scf-net-smcore.sh -d:"$td" -n:"$cn"
    git add . > /dev/null 2>&1
    git commit -m "submodule $cn created" > /dev/null 2>&1
    git push -u origin master > /dev/null 2>&1

    # create superproject adding core submodule
    git clone $su$sn $sd/$sn > /dev/null 2>&1
    cd $sd/$sn
    slb-git-scf-net-spbase.sh -d:"$sd" -n:"$sn" -c:"$cn"
    git add . > /dev/null 2>&1
    git commit -m "superproject $sn created" > /dev/null 2>&1
    git submodule add $cu$cn modules/$cn > /dev/null 2>&1
    git add . > /dev/null 2>&1
    git commit -m "submodule $cn added to superproject $sn" > /dev/null 2>&1
    git push -u origin master > /dev/null 2>&1

    # delete temp dir
    rm -rf $td
}

#..................................................................................
# Generate superproject adding existent core
#
genSuperAddCore()
{
     # create superproject adding core submodule
    git clone $su$sn $sd/$sn > /dev/null 2>&1
    cd $sd/$sn
    slb-git-scf-net-spbase.sh -d:"$sd" -n:"$sn" -c:"$cn"
    git add . > /dev/null 2>&1
    git commit -m "superproject $sn created" > /dev/null 2>&1
    git submodule add $cu$cn modules/$cn > /dev/null 2>&1
    git add . > /dev/null 2>&1
    git commit -m "submodule $cn added to superproject $sn" > /dev/null 2>&1
    git push -u origin master > /dev/null 2>&1
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