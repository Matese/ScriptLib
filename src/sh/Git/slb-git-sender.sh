#!/bin/bash
# Script to save supermodule and it´s submodules

if [ -d .git ]; then
    if [ -z "$1" ]; then
        echo "fatal: (null) is not a valid branch"
    else
        git submodule foreach git pull origin ${1}
        git pull origin ${1}
    fi;
else
    echo "fatal: not a git repository (or any of the parent directories)"
fi;