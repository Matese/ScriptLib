#!/bin/bash
# Script to set temper if status has changes

if [[ `git status ${1} --porcelain` ]]; 
then
    git temper "There are changes in ${1}"
fi;