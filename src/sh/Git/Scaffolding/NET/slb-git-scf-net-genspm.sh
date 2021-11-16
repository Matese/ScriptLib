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
#     -> https://stackoverflow.com/questions/7632454/how-do-you-use-git-bare-init-repository
#     -> https://superuser.com/questions/227509/git-ping-check-if-remote-repository-exists
#     -> https://unix.stackexchange.com/questions/45676/how-do-i-remove-a-directory-and-all-its-contents
#     -> https://unix.stackexchange.com/questions/462701/how-to-get-the-current-path-without-last-folder-in-a-script
#     -> https://www.cyberciti.biz/faq/bash-check-if-string-starts-with-character-such-as/
#     -> https://www.cyberciti.biz/faq/linux-bash-exit-status-set-exit-statusin-bash/
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

    sd=$sd/"repos"

    # shellcheck disable=SC2154,SC2086
    if defined $md && defined $mu && defined $mn; then

        if unvalued "md" $md; then return 1; fi
        if unvalued "mu" $mu; then return 1; fi
        if unvalued "mn" $mn; then return 1; fi

        md=$md/"repos"

        isCore=false

    elif defined $cd && defined $cu && defined $cn; then

        if unvalued "cd" $cd; then return 1; fi
        if unvalued "cu" $cu; then return 1; fi
        if unvalued "cn" $cn; then return 1; fi

        cd=$cd/"repos"

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

    # add group
    su=$su$(getGroup "$sn")/
    cu=$cu$(getGroup "$cn")/
    mu=$mu$(getGroup "$mn")/

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
                genRepo "$mu" "$mn"
                genSubInSuper "$mn" "$sn"
            fi
        fi
    else
        if [ $isCore == true ]; then
            genRepo "$su" "$sn"
            genRepo "$cu" "$cn"
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
# Check if a url is valid
#
isValidUrl()
{
    # regex to check if a URL valid
    regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'

    if [[ $1 =~ $regex ]]; then
        return 0 # true
    fi

    return 1 # false
}

#..................................................................................
# Check if a remote repository exists
#
remoteExists()
{
    if git ls-remote -h "$1" &> /dev/null; then
       return 0 # true
    fi

    return 1 # false
}

#..................................................................................
# Generate repository
#
genRepo()
{
    u=$1 # upstream
    n=$2 # name

    if isValidUrl "$u$n"; then

        # check if upstream starts with
        if [[ $u = https://gitlab.com/* ]]; then
            genRepoGitlab "$u" "$n"

        # check if upstream starts with
        elif [[ $u = https://github.com/* ]]; then
            genRepoGithub "$u" "$n"

        # check if upstream starts with
        elif [[ $u = https://dev.azure.com/* ]]; then
            genRepoAzure "$u" "$n"

        else
            echo "invalid upstream"
        fi

    else
        genRepoLocal "$u" "$n"
    fi
}

#..................................................................................
# Generate azure repository
#
genRepoAzure()
{
    echo "TODO: genRepoAzure"
}

#..................................................................................
# Generate github repository
#
genRepoGithub()
{
    echo "TODO: genRepoGithub"
}

#..................................................................................
# Generate gitlab repository
#
genRepoGitlab()
{
    groupId=$(gitlabGetGroupId "$2")

    if [ "$groupId" == "" ]; then
        echo "Group not found!"
    else
        if remoteExists "$1$2"; then
            echo "repo already exists: $1$2"
        else
            id=$(gitlabCreateProject "$2" "$groupId")

            if [ "$id" == "null" ]; then
                echo "repo creation failed!"
            else
                echo "repo created: $2 [id=$id]"
            fi

        fi
    fi
}

#..................................................................................
# Generate local repository
#
genRepoLocal()
{
    # check if directory exist
    if [ -d "$1$2.git" ]; then
        echo "repo already exists: $1$2.git"
    else
        # initialize a bare local repo
        git init --bare "$1$2.git"
        echo "repo created: $2"
    fi
}

#..................................................................................
# Generate submodule in superproject
#
genSubInSuper()
{
    # clone supermodule if needed
    if [ ! -d "$sd/$sn" ]; then
        git clone "$su$sn" "$sd/$sn"
    fi

    # get core name from superproject
    cn=$(head -n 1 "$sd/$sn/.root")

    # create temp dir
    td=$(mktemp -d)

    # create submodule
    git clone "$mu$mn" "$td/$mn"
    cd "$td/$mn" || exit
    slb-git-scf-net-smbase.sh -d:"$td" -n:"$mn"
    slb-symlnk.sh -f -l:".gitignore" -t:"../$cn/src/Git/.gitignore"
    slb-symlnk.sh -f -l:".gitattributes" -t:"../$cn/src/Git/.gitattributes"
    git add .
    git commit -m "submodule $mn created"
    git branch -m master
    git push -u origin master

    # add submodule to superproject
    cd "$sd/$sn" || exit
    git submodule add "$mu$mn" "modules/$mn"
    git add .
    git commit -m "submodule $mn added to superproject $sn"
    git branch -m master
    git push -u origin master

    # delete temp dir
    rm -rf "$td"

    echo "Created Submodule '$1' in Superproject '$2'"
}

#..................................................................................
# Add submodule in superproject
#
addSubInSuper()
{
    # add submodule to superproject
    cd "$sd/$sn" || exit
    git submodule add "$mu$mn" "modules/$mn"
    git add .
    git commit -m "submodule $mn added to superproject $sn"
    git branch -m master
    git push -u origin master

    echo "Added Submodule '$1' in Superproject '$2'"
}

#..................................................................................
# Generate superproject and core
#
genSuperGenCore()
{
    # create temp dir
    td=$(mktemp -d)

    # create core submodule
    git clone "$cu$cn" "$td/$cn"
    cd "$td/$cn" || exit
    slb-git-scf-net-smcore.sh -d:"$td" -n:"$cn"
    git add .
    git commit -m "submodule $cn created"
    git branch -m master
    git push -u origin master

    # create superproject adding core submodule
    git clone "$su$sn" "$sd/$sn"
    cd "$sd/$sn" || exit
    slb-git-scf-net-spbase.sh -d:"$sd" -n:"$sn" -c:"$cn"
    git add .
    git commit -m "superproject $sn created"
    git submodule add "$cu$cn" "modules/$cn"
    git add .
    git commit -m "submodule $cn added to superproject $sn"
    git branch -m master
    git push -u origin master

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
    git clone "$su$sn" "$sd/$sn"
    cd "$sd/$sn" || exit
    slb-git-scf-net-spbase.sh -d:"$sd" -n:"$sn" -c:"$cn"
    git add .
    git commit -m "superproject $sn created"
    git submodule add "$cu$cn" "modules/$cn"
    git add .
    git commit -m "submodule $cn added to superproject $sn"
    git branch -m master
    git push -u origin master

    echo "Created Superproject '$1' adding existent Core Submodule '$2'"
}

#..................................................................................
# Get the value of the key
#
readKey()
{
    echo "$1" | jq -r ".$2"
}

#..................................................................................
# Get group
#
getGroup()
{
    # split the string based on the . delimiter
    readarray -d . -t strarr <<< "$1"

    echo "${strarr[0]}"
}

#..................................................................................
# Create Gitlab project
#
gitlabCreateProject()
{
    projectid=$( \
        curl -s --location \
            --request POST "https://gitlab.com/api/v4/projects" \
            --header "Authorization: Bearer $(slb.sh config -g:"upsapi")" \
            --data-urlencode "name=$1" \
            --data-urlencode "visibility=private" \
            --data-urlencode "namespace_id=$2" | \
        jq '.id' \
    )

    echo "$projectid"
}

#..................................................................................
# Get gitlab group ID
#
gitlabGetGroupId()
{
    group=$(getGroup "$1")

    # foreach group
    gitlabGetGroups && for g in "${groups[@]}"; do

        # if group found
        if [ "$(readKey "$g" name)" == "$group" ]; then
            readKey "$g" id
            return 0 # true
        fi

    done

    return 1 # false
}

#..................................................................................
# Get gitlab groups list
#
gitlabGetGroups()
{
    mapfile -t groups < <( \
        curl -s --location \
            --request GET "https://gitlab.com/api/v4/groups/$(slb.sh config -g:"upsgid")/subgroups" \
            --header "Authorization: Bearer $(slb.sh config -g:"upsapi")" | \
        jq -c '.[]|{id:.id,name:.name}' \
    )
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