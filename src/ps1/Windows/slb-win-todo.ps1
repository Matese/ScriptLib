#slb-win-todo.ps1 Version 0.1
#..................................................................................
# Description:
#   TODO
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
#   Inspired by
#     -> todo
#..................................................................................

#..................................................................................
# The main entry point for the script
#
function main {
    Param($vargs)

    # default help
    $null = . slb-helper.ps1 @vargs | Where-Object { if ($_ -eq "0") { Exit } }

    # parse the arguments
    . slb-argadd.ps1 @vargs ; foreach ($var in $vargs) { New-Variable -Name $var[0] -Value $var[1] }

    Write-Host $todo
}

#..................................................................................
# Calls the main script
#
main $args

#..................................................................................
#..HELP...
#/
#/ TODO
#/
#/ slb-win-todo.ps1 [-v] [/?]
#/   -v         Shows the script version
#/   /?         Shows this help