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

    # Cache file
    f=$HOME/.scriptlib.lister

    # Should rebuild cache
    if [ ! -z ${c+x} ]; then rm $f; fi

    # If file do not exist
    if [[ ! -f $f ]]; then
        echo "Please wait..."
        getSubroups "$(slb.sh config -g:"upsgid")"

        echo $newtext >> $f

        for g in "${groups[@]}"; do
            echo "Group: $(echo $g | jq -r '.name')" >> $f
            echo "" >> $f
            getProjects "$(echo $g | jq -r '.id')"
            for p in "${projects[@]}"; do
                getIsSuper "$(echo $p | jq -r '.id')"
                if [ $isSuper = true ]; then
                    echo "   Repo: $(echo $p | jq -r '.name') (Superproject)" >> $f
                else
                    echo "   Repo: $(echo $p | jq -r '.name')" >> $f
                fi
                echo "   				 			 SSH: $(echo $p | jq -r '.surl')" >> $f
                echo "   				 			HTTP: $(echo $p | jq -r '.hurl')" >> $f
            done
        done
    fi

    # Read file
    while IFS= read -r line; do
        printf '%s\n' "$line"
    done < $f
}

#..................................................................................
# Get subgroups list
#
getSubroups()
{
    mapfile -t groups < <( curl -s --location \
    --request GET "https://gitlab.com/api/v4/groups/$1/subgroups" \
    --header "Authorization: Bearer $(slb.sh config -g:"upsapi")" \
    | jq -c '.[]|{id:.id,name:.name}' )
}

#..................................................................................
# Get projects list
#
getProjects()
{
    mapfile -t projects < <( curl -s --location \
    --request GET "https://gitlab.com/api/v4/groups/$1" \
    --header "Authorization: Bearer $(slb.sh config -g:"upsapi")" \
    | jq -c '.projects[]|{id:.id,name:.name,surl:.ssh_url_to_repo,hurl:.http_url_to_repo}' )
}

#..................................................................................
# Check if repository is a Superproject
#
getIsSuper()
{
    value=$( curl -s --location \
    --request GET "https://gitlab.com/api/v4/projects/$1/repository/tree" \
    --header "Authorization: Bearer $(slb.sh config -g:"upsapi")" \
    | jq -c '.[]|select(.name == ".Docker" ).name' )

    isSuper=true
    if [ "" == "$value" ]; then
        isSuper=false
    fi
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
#/   -c         Cache rebuild
#/   -v         Shows the script version
#/   /?         Shows this help