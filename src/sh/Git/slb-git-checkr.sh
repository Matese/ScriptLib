#!/bin/bash
# Script to just check for changes in supermodule and it´s submodules

if [ -d .git ]; then
    echo "checking submodules..." && git submodule foreach --quiet 'git wisher $toplevel/$name' 
    echo "checking superproject..." && git wisher $PWD
else
    echo "fatal: not a git repository (or any of the parent directories)"
fi;