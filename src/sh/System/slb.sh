#!/bin/bash
#slb.sh Version 0.1
#..................................................................................
# Description:
#   ScriptLib command invoker
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://linuxize.com/post/how-to-create-bash-aliases/
#     -> https://stackoverflow.com/questions/37104273/how-to-set-aliases-in-the-git-bash-for-windows
#     -> https://www.baeldung.com/linux/delete-lines-containing-string-from-file
#..................................................................................

#..................................................................................
# The main entry point for the script
#
main()
{
    # parse command
    cmd=$1
    if [ "$cmd" == "config" ]; then cmd=slb-git-config; fi
    if [ "$cmd" == "getter" ]; then cmd=slb-git-getter; fi
    if [ "$cmd" == "lister" ]; then cmd=slb-git-lister; fi
    if [ "$cmd" == "puller" ]; then cmd=slb-git-puller; fi
    if [ "$cmd" == "scfdng" ]; then cmd=slb-git-scfdng; fi
    if [ "$cmd" == "sender" ]; then cmd=slb-git-sender; fi
    if [ "$cmd" == "stater" ]; then cmd=slb-git-stater; fi
    if [ "$cmd" == "ostype" ]; then cmd=slb-ostype; fi
    if [ "$cmd" == "symlnk" ]; then cmd=slb-symlnk; fi
    if [ "$cmd" == "uuider" ]; then cmd=slb-uuider; fi

    # default help
    if [ "$cmd" == "-v" ] || [ "$cmd" == "--version" ] || [ "$cmd" == "--help" ] || [ "$cmd" == "/?" ]; then
        # shellcheck disable=1091
        . slb-helper.sh && return 0
    fi

    # get all arguments but first and invoke the script
    if [ "$cmd" != "" ]; then $cmd.sh "${@:2}"; fi
}

#..................................................................................
# Calls the main script
#
main "$@"

#..................................................................................
#..HELP...
#/
#/ ScriptLib command invoker.
#/
#/ slb [command] [-v] [/?]
#/
#/  (Git)
#/   config      Create git configurations
#/   getter      Clone projects and modules
#/   lister      List projects and modules
#/   puller      Pull projects and modules
#/   scfdng      Scaffold projects and modules
#/   sender      Save projects and modules
#/   stater      Check for status changes
#/   updter      Update projects and modules
#/
#/  (System)
#/   ostype      Detect Operational System type.
#/   symlnk      Create symlink
#/   uuider      Generate a pseudo UUID.
#/   -v          Shows the batch version
#/   /?          Help
#/