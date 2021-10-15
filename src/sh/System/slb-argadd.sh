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
string="$@"
results=()
result=''
inside=''
for (( i=0 ; i<${#string} ; i++ )) ; do
    char=${string:i:1}
    if [[ $inside ]] ; then
        if [[ $char == \\ ]] ; then
            if [[ $inside=='"' && ${string:i+1:1} == '"' ]] ; then
                let i++
                char=$inside
            fi
        elif [[ $char == $inside ]] ; then
            inside=''
        fi
    else
        if [[ $char == ["'"'"'] ]] ; then
            inside=$char
        elif [[ $char == ' ' ]] ; then
            char=''
            results+=("$result")
            result=''
        fi
    fi
    result+=$char
done

results+=("$result")

if [[ $inside ]] ; then
    echo Error parsing "$result"
    exit 1
fi

for r in "${results[@]}" ; do
    if [[ $r == *"-"* ]]; then
        keytempvar=${r%%:*}           # Remove all after first ":"
        keytempvar="${keytempvar/-/}" # Remove starting dash
        valuetempvar=${r#*:}          # Remove everything up to :

        # Remove double quotes
        if [[ $valuetempvar == \"*\" ]]; then
            valuetempvar="${valuetempvar:1:-1}";
        fi

        declare $keytempvar="${valuetempvar}"
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