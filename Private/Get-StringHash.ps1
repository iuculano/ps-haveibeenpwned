<#
    .SYNOPSIS
    Returns the hash of a string.
    
    .DESCRIPTION
    Get-StringHash computes and returns the hash of a string according to
    the HashType parameter. Not much more to it.

    .PARAMETER String
    Input string to generate a hash of.

    .PARAMETER HashType
    The type of hash to generate from the input string.

    .NOTES
    See the following for more details, especially the hash types. 
    Kind of strange how this API works...
    https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.hashalgorithm.create?view=netframework-4.7.2


    Get-StringHash.ps1
    Alex Iuculano, 2018
#>

function Get-StringHash
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$String,

        [Parameter(Position = 1)]
        [ValidateSet("SHA1", "SHA256", "SHA384", "SHA512", "MD5")]
        [String]$HashType = "SHA256"
    )


    Begin
    {
        # Honestly not sure if it's worth it to use a StringBuilder
        # since we're appending individual characters...
        $sb     = [System.Text.StringBuilder]::New()
        $hasher = [System.Security.Cryptography.HashAlgorithm]::Create($HashType)
    }

    Process
    {
        foreach ($str in $String)
        {
            # https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.hashalgorithm.computehash?view=netframework-4.8
            $bytes = $hasher.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))
            foreach ($byte in $bytes)
            {
                # Hex
                [Void]$sb.Append($byte.ToString("X2"))
            }

            $output = $sb.ToString()            
            [Void]$sb.Clear() # Need to cast to Void, otherwise this writes to the pipeline


            $output
        }
    }
}
