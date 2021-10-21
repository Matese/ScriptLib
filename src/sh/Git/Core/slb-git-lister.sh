#!/bin/bash
#slb-git-lister.sh Version 0.1
#..................................................................................
# Description:
#   List repositories
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://shapeshed.com/jq-json/
#     -> https://stackoverflow.com/questions/24254064/how-to-get-curl-to-output-only-http-response-body-json-and-no-other-headers-et
#     -> https://stackoverflow.com/questions/25320928/how-to-capture-the-output-of-curl-to-variable-in-bash
#     -> https://stackoverflow.com/questions/47660015/run-a-command-for-each-item-in-jq-array
#     -> https://unix.stackexchange.com/questions/551193/how-to-find-value-of-key-value-in-json-in-bash-script
#     -> https://stackoverflow.com/questions/2524367/inline-comments-for-bash
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

    # cache file
    f="$HOME/.scriptlib.lister"

    # shellcheck disable=SC2154,SC2086
    if defined $cr; then `# delete file to force cache rebuild` rm "$f"; fi

    # rebuild cache if file inexists
    if inexists "$f"; then

        echo "Please wait..."

        # foreach group
        getGroups && for g in "${groups[@]}"; do

            addGroup "$g" "$f"

            # foreach project
            getProjects "$(readKey "$g" id)" && for p in "${projects[@]}"; do

                addRepo "$p" "$f"

            done

        done
    fi

    # read cache file
    readCache "$f"
}

#..................................................................................
# Get the value of the key
#
readKey()
{
    echo "$1" | jq -r ".$2"
}

#..................................................................................
# Read cache file
#
readCache()
{
    while IFS= read -r line; do
        printf '%s\n' "$line"
    done <"$1"
}

#..................................................................................
# Add group to file
#
addGroup()
{
    echo "Group: $(readKey "$1" name)" >>"$2"
    echo "" >>"$2"
}

#..................................................................................
# Add repo to file
#
addRepo()
{
    {
        if super "$(readKey "$1" id)"; then echo "   (Superproject)"; fi
        echo "   Repo: $(readKey "$1" name)"
        echo "   				 			 SSH: $(readKey "$1" surl)"
        echo "   				 			HTTP: $(readKey "$1" hurl)"
    } >>"$2"
}

#..................................................................................
# Get groups list
#
getGroups()
{
    mapfile -t groups < <( \
        curl -s --location \
            --request GET "https://gitlab.com/api/v4/groups/$(slb.sh config -g:"upsgid")/subgroups" \
            --header "Authorization: Bearer $(slb.sh config -g:"upsapi")" | \
        jq -c '.[]|{id:.id,name:.name}' \
    )
}

#..................................................................................
# Get projects list
#
getProjects()
{
    mapfile -t projects < <( \
        curl -s --location \
            --request GET "https://gitlab.com/api/v4/groups/$1" \
            --header "Authorization: Bearer $(slb.sh config -g:"upsapi")" | \
        jq -c '.projects[]|{id:.id,name:.name,surl:.ssh_url_to_repo,hurl:.http_url_to_repo}' \
    )
}

#..................................................................................
# Check if repository is a Superproject
#
super()
{
    value=$( \
        curl -s --location \
            --request GET "https://gitlab.com/api/v4/projects/$1/repository/tree" \
            --header "Authorization: Bearer $(slb.sh config -g:"upsapi")" | \
        jq -c '.[]|select(.name == ".root" ).name' \
    )

    if [ "" == "$value" ]; then
        return 1 # false
    fi

    return 0 # true
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
# Check if file inexists
#
inexists()
{
    # if file do not exist
    if [[ ! -f $1 ]]; then
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
#/ List repositories
#/
#/ slb-git-lister.sh [-s] [-r] [-v] [/?]
#/   -cr        Cache rebuild
#/   -v         Shows the script version
#/   /?         Shows this help
