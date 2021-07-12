. "$PSScriptRoot\..\..\Private\Get-StringHash.ps1"
. "$PSScriptRoot\..\..\Public\Get-HIBPPassword.ps1"


Describe "Get-HIBPEmail" {

    Context "Parameter validation" {

        It "Should throw on blank or empty input" {

            { Get-HIBPPassword ""    } | Should -Throw
            { Get-HIBPPassword @()   } | Should -Throw
            { Get-HIBPPassword $null } | Should -Throw            
        }
    }

    Context "Results" {

        It "Should return data for a valid lookup" {

            $result = Get-HIBPPassword "test"
            $result |  Should -BeTrue
        }

        It "Should return nothing for invalid lookup" {

            $result = Get-HIBPPassword "12309FAKE_PASSWORD_THIS_WILL_NEVER_WORK12309"
            $result | Should -BeFalse
        }
    }
}
