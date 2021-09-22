#!/bin/bash
# Script to update supermodule and it´s submodules

if [ -d .git ]; then
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>&1)

    git temper null && echo "checking submodules..."
    git submodule foreach --quiet 'git wisher $toplevel/$name' 
    git submodule foreach --quiet 'git stater $toplevel/$name'
    VALUE=`cat /tmp/TEMPERVAR.dat`

    if [ "$VALUE" == "null" ]; then
        git submodule foreach --quiet "git pull --quiet origin $CURRENT_BRANCH"
        git submodule foreach --quiet 'git stater $toplevel/$name' && VALUE=`cat /tmp/TEMPERVAR.dat`

        if [ "$VALUE" == "null" ]; then
            echo "checking superproject..." && git wisher $PWD && git stater $PWD && VALUE=`cat /tmp/TEMPERVAR.dat`

            if [ "$VALUE" == "null" ]; then
                git pull --quiet origin $CURRENT_BRANCH && git stater $PWD && VALUE=`cat /tmp/TEMPERVAR.dat`

                if [ "$VALUE" == "null" ]; then
                    git submodule foreach --quiet "git push --quiet origin $CURRENT_BRANCH"
                    git push --quiet origin $CURRENT_BRANCH
                    git submodule foreach --quiet "git pull --quiet"
                    git pull --quiet
                    git submodule foreach --quiet 'git fetch --dry-run'
                    git fetch --dry-run
                    echo "finished"
                else
                    echo "fatal: cannot save. "$VALUE
                fi;
            else
                echo "fatal: cannot save. "$VALUE
            fi;
        else
            echo "fatal: cannot save. "$VALUE
        fi;
    else
        echo "fatal: cannot save. "$VALUE
    fi;
else
    echo "fatal: not a git repository (or any of the parent directories)"
fi;