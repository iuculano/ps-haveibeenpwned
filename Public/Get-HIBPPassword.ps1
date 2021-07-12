<#
    .SYNOPSIS
    Queries HaveIBeenPwned API to check whether a given password has
    been involved in a breach.
    
    .DESCRIPTION
    Queries HaveIBeenPwned API to check whether a given password has
    been involved in a breach.

    .PARAMETER Password
    Specifies passwords to query.

    .NOTES
    As of API V3, this requires an API key and is no longer free. :(

    Yes - I know PSScriptAnalyzer complains because of the Password parameter.

    
    Get-HIBPPassword.ps1
    Alex Iuculano, 2018
#>

function Get-HIBPPassword
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Password
    )


    Process
    {
        foreach ($pass in $Password)
        {
            # Hash our string
            $hash       = Get-StringHash -String $pass -HashType SHA1
            $hashPrefix = $hash.Substring(0, 5)
            $hashSuffix = $hash.Substring(5)
            
            # Make and filter the call
            $request    = Invoke-RestMethod -Uri "https://api.pwnedpasswords.com/range/$hashPrefix"
            $result     = $request -match "($hashSuffix):(\d{1,16})"
            # $filtered = [String[]]($request -split ":.+").Trim().Where({ $_ -ne [String]::Empty })
            # $result   = $filtered.Contains($hashSuffix)

            
            if ($result)
            {
                # Returns the matched password, its hash, and the number of times
                # that it was seen within breaches.
                [PSCustomObject]@{
                    Password = $pass
                    Hash     = $Matches[1]
                    Count    = $Matches[2]
                }
            }
        }
    }
}
