#!/bin/bash
#slb-git-chkred.sh Version 0.1
#..................................................................................
# Description:
#   Check git redirection warning
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://stackoverflow.com/questions/53012504/what-does-the-warning-redirecting-to-actually-mean
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

    # check if is a git repository directory
    if git rev-parse --git-dir > /dev/null 2>&1; then
        remote_name="$(git remote)";
        wrong_remote_path="$(git remote get-url "$remote_name")";
        correct_remote_path="$(git fetch --dry-run 2> >(awk '/warning: redirecting to/ { print $4}'))";
        if [ -z "${correct_remote_path-}" ]; then
            printf "The path of the remote '%s' is already correct\n" "$remote_name";
        else
            printf "Command to change the path of remote '%s'\nfrom '%s'\n  to '%s'\n" "$remote_name" "$wrong_remote_path" "$correct_remote_path";
            printf "git remote set-url %s %s\n" "$remote_name" "$correct_remote_path";
        fi
    else
        echo "fatal: not a git repository (or any of the parent directories)"
    fi;
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Check git redirection warning.
#/
#/ slb-git-chkred.sh [-v] [/?]
#/   -v         Shows the script version
#/   /?         Shows this help