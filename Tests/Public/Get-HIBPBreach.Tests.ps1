. "$PSScriptRoot\..\..\Public\Get-HIBPAccount.ps1"


Describe "Get-HIBPAccount" {

    Context "Parameter validation" {

        It "Should throw 404 on no match" {

            { Get-HIBPBreach "NO MATCHES PLZ asdfhjadfsjkhINSAFIOs.net" } | Should -Throw
        }
    }
}
