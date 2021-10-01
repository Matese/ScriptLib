#slb-win-slperm.ps1 Version 0.1
#..................................................................................
# Description:
#   Add Symlink permissions to Local Security Policy
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
#   Inspired by
#     -> https://dbondarchuk.com/2016/09/23/adding-permission-for-creating-symlink-using-powershell/
#     -> https://megamorf.gitlab.io/2020/05/26/check-if-powershell-is-running-as-administrator/
#     -> https://community.spiceworks.com/how_to/2776-powershell-sid-to-user-and-user-to-sid
#     -> https://www.red-gate.com/simple-talk/sysadmin/powershell/how-to-add-help-to-powershell-scripts/
#     -> https://www.jonathanmedd.net/2015/01/how-to-make-use-of-functions-in-powershell.html
#     -> https://devblogs.microsoft.com/powershell/suppressing-return-values-in-powershell-functions/
#     -> https://dotnet-helpers.com/powershell/how-to-use-multidimensional-arrays-in-powershell/
#..................................................................................

#..................................................................................
# The main entry point for the script
#
function main {
    Param($vargs)

    # default help
    $null = . slb-helper.ps1 @vargs | Where-Object { if ($_ -eq "0") { Exit } }

    # check if is running as admin
    checkPermission

    # get sids
    $currentUserSid = getCurrentUserSid
    $securityPolicySid = getSecurityPolicySid

    # check if needs to add symlink permission
    if (-not $securityPolicySid.Contains($currentUserSid)) {
        addSymlinkPermission $currentUserSid $securityPolicySid
    }
    else {
        Write-Host "Account already in ""Create SymLink""" -ForegroundColor Green
    }
}

#..................................................................................
# Check if it is running as admin
#
function checkPermission {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()

    # if not running as admin
    if (-not ($identity.Groups -contains 'S-1-5-32-544')) {
        Write-Host "You do not have sufficient permissions to perform this command." -ForegroundColor Red
        exit -1
    }
}

#..................................................................................
# Get the logged user SID
#
function getCurrentUserSid {
    try {
        $user = (Get-ChildItem Env:\USERNAME).Value
        $account = New-Object System.Security.Principal.NTAccount($env:USERDOMAIN, $user)
        $sid = "*" + $account.Translate([System.Security.Principal.SecurityIdentifier]).Value.ToString()
    }
    catch {
        $sid = $null
    }

    if ( [string]::IsNullOrEmpty($sid) ) {
        Write-Host "Account not found!" -ForegroundColor Red
        exit -1
    }

    return $sid
}

#..................................................................................
# Get Local Security Policy SECreateSymbolicLinkPrivilege SID
#
function getSecurityPolicySid {
    $tmp = [System.IO.Path]::GetTempFileName()
    $null = secedit.exe /export /cfg "$($tmp)"
    $content = Get-Content -Path $tmp

    try {
        foreach ($c in $content) {
            if ( $c -like "SECreateSymbolicLinkPrivilege*") {
                $users = $c.split("=", [System.StringSplitOptions]::RemoveEmptyEntries)[1].Trim().split(",")

                foreach ($user in $users) {
                    $account = New-Object System.Security.Principal.NTAccount($user)
                    $sid += "*" + $account.Translate([System.Security.Principal.SecurityIdentifier]).Value.ToString() + ","
                }

                # remove last character
                $sid = $sid.Substring(0, $sid.Length - 1)
            }
        }
    }
    catch {
        $sid = $null
    }

    return $sid
}

#..................................................................................
# Add Symlink permissions to Local Security Policy
#
function addSymlinkPermission {
    Param($currentUserSid, $securityPolicySid)

    Write-Host "Need to add permissions to SymLink" -ForegroundColor Yellow

    if ( [string]::IsNullOrEmpty($securityPolicySid) ) {
        $securityPolicySid = "$($currentUserSid)"
    }
    else {
        $securityPolicySid = "$($currentUserSid),$($securityPolicySid)"
    }

    $outfile = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
Revision=1
[Privilege Rights]
SECreateSymbolicLinkPrivilege = $($securityPolicySid)
"@

    $tmp = [System.IO.Path]::GetTempFileName()
    Write-Host "Import new settings to Local Security Policy" -ForegroundColor DarkCyan
    $outfile | Set-Content -Path $tmp -Encoding Unicode -Force
    Push-Location (Split-Path $tmp)

    try {
        secedit.exe /configure /db "secedit.sdb" /cfg "$($tmp)" /areas USER_RIGHTS
    }
    finally {
        Pop-Location
    }
}

#..................................................................................
# Calls the main script
#
main $args

#..................................................................................
#..HELP...
#/
#/ Add Symlink permissions to Local Security Policy.
#/
#/ slb-win-slperm.ps1 [-v] [/?]
#/   -v         Shows the script version
#/   /?         Shows this help