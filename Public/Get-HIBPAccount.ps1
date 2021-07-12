<#
    .SYNOPSIS
    Queries the Have I Been Pwned API to check for breaches involving a given
    e-mail account.
    
    .DESCRIPTION
    Queries the Have I Been Pwned API to check for breaches involving a given
    e-mail account.

    .PARAMETER Account
    Specifies email addresses to query.

    .PARAMETER Domain
    Specifies a specific domain to query for.

    .PARAMETER TruncateResponse
    Specifies whether to return a more detailed response, includes information 
    about each breach.

    This is disabled by default.

    .PARAMETER IncludeUnverified
    Specifies whether to include univerified results.

    This is enabled by default.

    .PARAMETER APIKey
    Specifies a HaveIBeenPwned API Key.

    .NOTES
    As of API V3, this requires an API key and is no longer free. :(
    See here for more detail: 
    1. https://haveibeenpwned.com/API/v3
    2. https://haveibeenpwned.com/API/Key


    Also, this function does some basic rate limiting internally.
    If you're calling this function repeatedly, you will need to do the same.

    By default, it will stall subsequent requests by 1600 milliseconds.

    
    Get-HIBPEmail.ps1
    Alex Iuculano, 2018
#>

function Get-HIBPAccount
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory         = $true,
                   ValueFromPipeline = $true)]
        [String[]]$Account,

        [APIQueryStringAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Domain,

        [APIQueryStringAttribute()]
        [Bool]$TruncateResponse,

        [APIQueryStringAttribute]
        [Bool]$IncludeUnverified,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$APIKey
    )

    
    Begin
    {
        # This is pretty simple / naive and just stalls by 1600ms for subsequent requests
        $needsToRateLimit = $false
    }

    Process
    {
        foreach ($email in $Account)
        {
            if ($needsToRateLimit)
            {
                Start-Sleep -Milliseconds 1600
            }
            

            $endpoint  = "https://haveibeenpwned.com/api/v3/breachedaccount/$email"
            $endpoint += ConvertTo-HIBPQueryString $PSCmdlet            
            $irmArgs   =
            @{
                Uri       = $endpoint
                UserAgent = "PSHaveIBeenPwned"
                Headers   = @{ "hibp-api-key" = $APIKey }
            }
            

            try
            {
                $response = $null
                $response = Invoke-RestMethod @irmArgs
            }

            catch
            {
                $exception = $_

                switch ([Int32]$_.Exception.Response.StatusCode)
                {
                    # Not found and rate-limited, respectively
                    { @(404, 429) -contains $_ }
                    {
                        Write-Error "$email - $exception"
                        continue
                    }

                    default
                    {
                        $PSCmdlet.ThrowTerminatingError($exception)
                    }
                }
            }

            $needsToRateLimit = $true

            if ($response)
            {
                [PSCustomObject]@{ 
                    EmailAddress = $email
                    Breaches     = @($response)
                }
            }
        }
    }
}
