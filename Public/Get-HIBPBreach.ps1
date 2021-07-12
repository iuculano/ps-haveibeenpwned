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

function Get-HIBPBreach
{


    [CmdletBinding(DefaultParameterSetName = "Default")]
    Param
    (
        [Parameter(ValueFromPipeline = $true,
                   ParameterSetName  = "Domain")]
        [APIQueryStringAttribute()]
        [String[]]$Domain
    )


    Process
    {
        switch ($PSCmdlet.ParameterSetName)
        {
            "Default"
            {
                $irmArgs  =
                @{
                    Uri       = "https://haveibeenpwned.com/api/v3/breaches"
                    UserAgent = "PSHaveIBeenPwned"
                }

                $response = $null
                $response = Invoke-RestMethod @irmArgs
                if ($response)
                {
                    @($response)
                }
            }

            "Domain"
            {
                foreach ($d in $Domain)
                {
                    $endpoint  = "https://haveibeenpwned.com/api/v3/breaches"
                    $endpoint += ConvertTo-HIBPQueryString $PSCmdlet

                    $irmArgs =
                    @{
                        Uri       = $endpoint
                        UserAgent = "PSHaveIBeenPwned"
                    }
            
                    $response = $null
                    $response = Invoke-RestMethod @irmArgs
                    if ($response)
                    {
                        [PSCustomObject]@{
                            Domain = $d
                            Breach = @($response)
                        }
                    }
                }
            }
        }
    } # Process
}
