. "$PSScriptRoot\..\..\Public\Get-HIBPAccount.ps1"


Describe "Get-HIBPAccount" {

    Context "Parameter validation" {

        It "Should throw on blank or empty input" {

            { Get-HIBPAccount ""    } | Should -Throw
            { Get-HIBPAccount @()   } | Should -Throw
            { Get-HIBPAccount $null } | Should -Throw            
        }

        It "Should throw on blank or empty API key" {

            { Get-HIBPAccount "Email@fake.net" -APIKey ""    } | Should -Throw
            { Get-HIBPAccount "Email@fake.net" -APIKey $null } | Should -Throw     
        }
    }
}
