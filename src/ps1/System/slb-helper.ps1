#slb-helper.ps1 Version 0.1
#..................................................................................
# Description:
#   Performs file documentation analysis.
#
# History:
#   - v0.1 2021-09-29 Initial release including basic documentation
#
# Remarks:
#   This script has the premise that the script passed as argument has the same
#   documentation convention as this script. In other words, the script passed as
#   argument should have "#/" before documentation lines.
#
#   Inspired by
#     -> https://stackoverflow.com/questions/40475853/how-to-find-location-path-of-current-script-in-powershell
#     -> https://powershell-guru.com/powershell-tip-145-select-string-cmdlet-with-case-sensitive-search/
#     -> https://ss64.com/ps/substring.html
#     -> https://superuser.com/questions/71446/equivalent-of-bashs-source-command-in-powershell
#     -> https://stackoverflow.com/questions/4875912/determine-if-powershell-script-has-been-dot-sourced
#     -> https://copdips.com/2018/09/terminate-powershell-script-or-session.html
#

#..................................................................................
# The main entry point for the script
#
function main {
    Param($vargs)

    foreach ($arg in $vargs) {
        if ( $arg -eq "-v" ) {
            showVersion ; if ($dotSourced) { Return 0 } else { Exit 0 }
        }
        elseif ( $arg -eq "--version" ) {
            showVersion ; if ($dotSourced) { Return 0 } else { Exit 0 }
        }
        elseif ( $arg -eq "--help" ) {
            showHelp ; if ($dotSourced) { Return 0 } else { Exit 0 }
        }
        elseif ( $arg -eq "/?" ) {
            showHelp ; if ($dotSourced) { Return 0 } else { Exit 0 }
        }
    }

    if ($dotSourced) { Return 1 } else { Exit 1 }
}

#..................................................................................
# Shows the documentation
#
function showHelp {
    Get-Content -Path $callerPath | Select-String -Pattern "^#/" | ForEach-Object {
        $str = "$_".TrimStart("#/")
        if ($str.Length -gt 0) { $str = $str.Substring(1) }
        Write-Host $str
    }
    Write-Host
}

#..................................................................................
# Shows the version
#
function showVersion {
    Write-Host
    Get-Content $callerPath -First 1 | Where-Object { Write-Host $_.TrimStart("#") }
    Write-Host
}

#..................................................................................
# Find out how the script was invoked
#
$dotSourced = $MyInvocation.InvocationName -eq '.' -or $MyInvocation.Line -eq ''
$callerPath = Get-Item (Get-PSCallStack)[(Get-PSCallStack).length - 2].ScriptName

#..................................................................................
# Calls the main script
#
main $args

#..................................................................................
#..HELP...
#/
#/ Performs sh file analysis discovering and displaying documentation if any.
#/ Documentation should follow the convention defined at the end of the script.
#/
#/ slb-helper.ps1 <FilePath> [-v] [/?]
#/   FilePath   File path to parse
#/   -v         Shows the script version
#/   /?         Shows this help