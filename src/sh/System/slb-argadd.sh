#!/bin/bash
#slb-argadd.sh Version 0.1
#..................................................................................
# Description:
#   Parse and define args to be used.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://janbio.home.blog/2020/03/18/remove-all-after-character-or-last-character-in-r
#     -> https://reactgo.com/bash-remove-first-last-character/
#     -> https://stackoverflow.com/questions/12821302/split-a-string-only-by-spaces-that-are-outside-quotes
#     -> https://stackoverflow.com/questions/12821302/split-a-string-only-by-spaces-that-are-outside-quotes
#     -> https://stackoverflow.com/questions/13437104/compare-content-of-two-variables-in-bash
#     -> https://stackoverflow.com/questions/20866832/is-it-possible-to-mimic-process-substitution-on-msys-mingw-with-bash-3-x
#     -> https://stackoverflow.com/questions/45921699/bash-substring-from-first-occurrence-of-a-character-to-the-second-occurrence
#     -> https://www.brianchildress.co/named-parameters-in-bash/
#..................................................................................

#..................................................................................
# The main entry point for the script
#
_s="$@" # string
_rs=()  # results
_v=''   # value
_in=''  # inside

for (( _i=0 ; _i<${#_s} ; _i++ )) ; do
    _c=${_s:_i:1}
    if [[ $_in ]] ; then
        if [[ $_c == \\ ]] ; then
            if [[ $_in=='"' && ${_s:_i+1:1} == '"' ]] ; then
                let i++
                _c=$_in
            fi
        elif [[ $_c == $_in ]] ; then
            _in=''
        fi
    else
        if [[ $_c == ["'"'"'] ]] ; then
            _in=$_c
        elif [[ $_c == ' ' ]] ; then
            _c=''
            _rs+=("$_v")
            _v=''
        fi
    fi
    _v+=$_c
done

_rs+=("$_v")

if [[ $_in ]] ; then
    echo Error parsing "$_v"
    exit 1
fi

for _r in "${_rs[@]}" ; do
    if [[ $_r == *"-"* ]]; then
        _k=${_r%%:*}  # Remove all after first ":"
        _k="${_k/-/}" # Remove starting dash
        _v=${_r#*:}   # Remove everything up to :

        # Remove double quotes
        if [[ $_v == \"*\" ]]; then
            _v="${_v:1:-1}";
        fi

        declare $_k="${_v}"
    fi
done

#..................................................................................
#..HELP...
#/
#/ Parse and define args to be used.
#/
#/ slb-argadd.sh Argument<:Value> <<ArgumentN>:<ValueN>> [-v] [/?]
#/   Argument   The name of the argument
#/   Value      The value of the argument (if nothing defined, defaults to 1)
#/   -v         Shows the script version
#/   /?         Shows this help