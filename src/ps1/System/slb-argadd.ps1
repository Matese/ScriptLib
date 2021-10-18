#slb-argadd.ps1 Version 0.1
#..................................................................................
# Description:
#   Parse and define args to be used.
#
# History:
#   - v0.1 2021-09-21 Initial versioned release with embedded documentation
#
# Remarks:
#   Inspired by
#     -> https://devblogs.microsoft.com/powershell/powershell-tip-how-to-shift-arrays/
#     -> https://stackoverflow.com/questions/13015303/dynamically-create-variables-in-powershell
#     -> https://stackoverflow.com/questions/1303921/passing-around-command-line-args-in-powershell-from-function-to-function
#     -> https://stackoverflow.com/questions/18877580/powershell-and-the-contains-operator
#     -> https://techcommunity.microsoft.com/t5/itops-talk-blog/powershell-basics-detecting-if-a-string-ends-with-a-certain/ba-p/307848
#..................................................................................

#..................................................................................
# Collect the arguments
#
$arguments = @()
$bypassNext = $False

for ($i = 0; $i -le $args.Length; $i++) {
    if ($bypassNext) {
        $bypassNext = $False
    }
    else {
        if ($args[$i] -match "-" -and $args[$i] -match "\:$" ) {
            $bypassNext = $True
            $arguments += $args[$i] + $args[$i + 1]
        }
        else {
            if ($args[$i].Length -gt 0) {
                $arguments += $args[$i]
            }
        }
    }
}

#..................................................................................
# Generate arguments
#
$vargs = @()
while ($arguments.Length -gt 0) {
    $arg, $arguments = $arguments

    if ( $arg -match "-" ) {

        try {
            # Remove all after first ":"
            $keytempvar = $arg.Substring(0, $arg.lastIndexOf(':'))
        }
        catch {
            # Do not have a ":" at the end
            $keytempvar = $arg
        }

        $keytempvar = $keytempvar.TrimStart("-")     # Remove starting dash
        $keytempvar = "_" + $keytempvar              # Add a underscore at the begining
        $valuetempvar = $arg.split(":")[1]           # Remove everything up to :
        if ($null -eq $valuetempvar) {
            $valuetempvar = $keytempvar
        }
        $vargs += , (@($keytempvar, $valuetempvar))
    }
}

#..................................................................................
#..HELP...
#/
#/ Parse and define args to be used.
#/
#/ slb-argadd.ps1 Argument<:Value> <<ArgumentN>:<ValueN>> [-v] [/?]
#/   Argument   The name of the argument
#/   Value      The value of the argument (if nothing defined, defaults to 1)
#/   -v         Shows the script version
#/   /?         Shows this help