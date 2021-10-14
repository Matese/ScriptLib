#!/bin/bash
#slb-git-updater.sh Version 0.1
#..................................................................................
# Description:
#   Update superproject and it´s submodules
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://git-scm.com/docs/git-submodule
#..................................................................................

#..................................................................................
# The main entry point for the script
#
main()
{
    # check if is a git repository directory
    if [ -d .git ]; then
        readBranchVar
        checkSubmodules
        checkSuperproject
    else
        echo "fatal: not a git repository (or any of the parent directories)"
    fi;
}

#..................................................................................
# Check the superproject
#
checkSuperproject()
{
    echo "checking superproject..." && git guider $PWD && git stater $PWD && readStaterVar

    if [ "$value" == "null" ]; then
        git pull --quiet origin $current_branch && git stater $PWD && readStaterVar

        if [ "$value" == "null" ]; then
            git submodule foreach --quiet "git push --quiet origin $current_branch"
            git push --quiet origin $current_branch
            git submodule foreach --quiet "git pull --quiet"
            git pull --quiet
            git submodule foreach --quiet 'git fetch --dry-run'
            git fetch --dry-run
            echo "finished"
        else
            echo "fatal: cannot save. "$value
        fi;
    else
        echo "fatal: cannot save. "$value
    fi;
}

#..................................................................................
# Check the submodules
#
checkSubmodules()
{
    echo "checking submodules..."

    # invoke git-gui if status has changes, and then check status
    nullSater && git submodule foreach --quiet 'git guider $toplevel/$name'
    git submodule foreach --quiet 'git stater $toplevel/$name' && readStaterVar

    if [ "$value" == "null" ]; then
        # invoke git pull, and then check status
        git submodule foreach --quiet "git pull --quiet origin $current_branch"
        git submodule foreach --quiet 'git stater $toplevel/$name' && readStaterVar
    else
        echo "fatal: cannot save. "$value
    fi;

    if [ "$value" != "null" ]; then
        echo "fatal: cannot save. "$value
        exit 0
    fi;
}

#..................................................................................
# Calls the main script
#
readBranchVar()
{
    current_branch=$(git rev-parse --abbrev-ref HEAD 2>&1)
}

#..................................................................................
# Save "null" in /tmp/slb-git-stater.dat
#
nullSater()
{
    echo "null" > /tmp/slb-git-stater.dat
}

#..................................................................................
# Read value from /tmp/slb-git-stater.dat
#
readStaterVar()
{
    value=`cat /tmp/slb-git-stater.dat`
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ Update superproject and it´s submodules.
#/
#/ slb-git-updter.sh [-dir:] [-v] [/?]
#/   -dir       Directory of the repository
#/   -v         Shows the script version
#/   /?         Shows this help