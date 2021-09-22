#!/bin/bash
# Script to clone supermodule and it´s submodules
# Remarks:
#   https://stackoverflow.com/questions/8967902/why-do-you-need-to-put-bin-bash-at-the-beginning-of-a-script-file
#   https://stackoverflow.com/questions/18096670/what-does-z-mean-in-bash

if [ -z "$1" ]; then
    echo "fatal: (null) is not a git repository"
else
    if [ -z "$2" ]; then
        echo "fatal: unexpected branch"
    else
        git clone "http://tfs.larnet:8080/tfs/DESENVOLVIMENTO/LARGIT/_git/${1}_super"
        cd "${1}_super"
        git submodule update --init
        git submodule foreach git checkout ${2}
        git checkout ${2}
    fi;
fi;