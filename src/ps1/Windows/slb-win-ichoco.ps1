#slb-win-ichoco.ps1 Version 0.1
#..................................................................................
# Description:
#   Chocolatey package manager installer
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
#   Inspired by
#     -> https://community.spiceworks.com/topic/2203658-check-if-choco-already-installed-and-install-if-not
#     -> https://docs.chocolatey.org/en-us/choco/uninstallation
#     -> https://stackoverflow.com/questions/3159949/in-powershell-how-do-i-test-whether-or-not-a-specific-variable-exists-in-global
#     -> https://stackoverflow.com/questions/48144104/powershell-script-to-install-chocolatey-and-a-list-of-packages
#     -> https://stackoverflow.com/questions/58560804/null-conditional-in-powershell
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

    if (($null -ne $_i) -And (Get-Variable $_i -ErrorAction 'Ignore')) {
        installChoco
    }
    elseif (($null -ne $_u) -And (Get-Variable $_u -ErrorAction 'Ignore')) {
        uninstallChoco
    }
    else {
        Write-Error "Command not found"
    }

    # clean arguments
    foreach ($var in $vargs) { Remove-Variable -Name $var[0] }
}

#..................................................................................
# Install Chocolatey
#
function installChoco {
    # if not installed
    If (!(Test-Path -Path "$env:ProgramData\Chocolatey")) {
        Write-Output "Seems Chocolatey is not installed, installing now"
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    else {
        Write-Output "Chocolatey is already installed"
    }
}

#..................................................................................
# Uninstall Chocolatey
#
function uninstallChoco {
    $VerbosePreference = 'Continue'
    if (-not $env:ChocolateyInstall) {
        $message = @(
            "The ChocolateyInstall environment variable was not found."
            "Chocolatey is not detected as installed. Nothing to do."
        ) -join "`n"

        Write-Warning $message
        return
    }

    if (-not (Test-Path $env:ChocolateyInstall)) {
        $message = @(
            "No Chocolatey installation detected at '$env:ChocolateyInstall'."
            "Nothing to do."
        ) -join "`n"

        Write-Warning $message
        return
    }

    <#
    Using the .NET registry calls is necessary here in order to preserve environment variables embedded in PATH values;
    Powershell's registry provider doesn't provide a method of preserving variable references, and we don't want to
    accidentally overwrite them with absolute path values. Where the registry allows us to see "%SystemRoot%" in a PATH
    entry, PowerShell's registry provider only sees "C:\Windows", for example.
#>
    $userKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment', $True)
    $userPath = $userKey.GetValue('PATH', [string]::Empty, 'DoNotExpandEnvironmentNames').ToString()

    $machineKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\ControlSet001\Control\Session Manager\Environment\', $True)
    $machinePath = $machineKey.GetValue('PATH', [string]::Empty, 'DoNotExpandEnvironmentNames').ToString()

    $backupPATHs = @(
        "User PATH: $userPath"
        "Machine PATH: $machinePath"
    )
    $backupFile = "C:\PATH_backups_ChocolateyUninstall.txt"
    $backupPATHs | Set-Content -Path $backupFile -Encoding UTF8 -Force

    $warningMessage = @"
    This could cause issues after reboot where nothing is found if something goes wrong.
    In that case, look at the backup file for the original PATH values in '$backupFile'.
"@

    if ($userPath -like "*$env:ChocolateyInstall*") {
        Write-Verbose "Chocolatey Install location found in User Path. Removing..."
        Write-Warning $warningMessage

        $newUserPATH = @(
            $userPath -split [System.IO.Path]::PathSeparator |
            Where-Object { $_ -and $_ -ne "$env:ChocolateyInstall\bin" }
        ) -join [System.IO.Path]::PathSeparator

        # NEVER use [Environment]::SetEnvironmentVariable() for PATH values; see https://github.com/dotnet/corefx/issues/36449
        # This issue exists in ALL released versions of .NET and .NET Core as of 12/19/2019
        $userKey.SetValue('PATH', $newUserPATH, 'ExpandString')
    }

    if ($machinePath -like "*$env:ChocolateyInstall*") {
        Write-Verbose "Chocolatey Install location found in Machine Path. Removing..."
        Write-Warning $warningMessage

        $newMachinePATH = @(
            $machinePath -split [System.IO.Path]::PathSeparator |
            Where-Object { $_ -and $_ -ne "$env:ChocolateyInstall\bin" }
        ) -join [System.IO.Path]::PathSeparator

        # NEVER use [Environment]::SetEnvironmentVariable() for PATH values; see https://github.com/dotnet/corefx/issues/36449
        # This issue exists in ALL released versions of .NET and .NET Core as of 12/19/2019
        $machineKey.SetValue('PATH', $newMachinePATH, 'ExpandString')
    }

    # Adapt for any services running in subfolders of ChocolateyInstall
    $agentService = Get-Service -Name chocolatey-agent -ErrorAction SilentlyContinue
    if ($agentService -and $agentService.Status -eq 'Running') {
        $agentService.Stop()
    }

    Remove-Item -Path $env:ChocolateyInstall -Recurse -Force

    'ChocolateyInstall', 'ChocolateyLastPathUpdate' | ForEach-Object {
        foreach ($scope in 'User', 'Machine') {
            [Environment]::SetEnvironmentVariable($_, [string]::Empty, $scope)
        }
    }

    $machineKey.Close()
    $userKey.Close()
}

#..................................................................................
# Calls the main script
#
main $args

#..................................................................................
#..HELP...
#/
#/ Chocolatey package manager installer
#/
#/ slb-win-ichoco.ps1 [-i] [-u] [-v] [/?]
#/   -i         Install
#/   -u         Uninstall
#/   -v         Shows the script version
#/   /?         Shows this help