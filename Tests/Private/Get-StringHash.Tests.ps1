. "$PSScriptRoot\..\..\Private\Get-StringHash.ps1"


Describe "Get-StringHash" {

    Context "Parameter validation" {

        It "Should throw on blank or empty input" {

            { Get-StringHash ""    } | Should -Throw
            { Get-StringHash @()   } | Should -Throw
            { Get-StringHash $null } | Should -Throw            
        }

        It "Should throw on invalid HashType" {

            { Get-StringHash "OK" -HashType "" }                   | Should -Throw
            { Get-StringHash "OK" -HashType "BlantlyInvalidType" } | Should -Throw
        }
    }
    
    Context "Hashing" { 

        # If you change this string, make sure you update the results.
        $stringToHash = "Testing, testing! One, two, three!"

        # These are generated with a 3rd party tool as a sanity check.
        $testCases =
        @(
            @{ String = $stringToHash; HashType = "SHA1"  ; HashOutput = "B976F649E28254B6A16FCADE029F0EB4783B659E" }
            @{ String = $stringToHash; HashType = "SHA256"; HashOutput = "ABC142CF92A23162603298106CB119E12929C27F660B849454D7A6BAD3429F05" }
            @{ String = $stringToHash; HashType = "SHA384"; HashOutput = "5E61CAE3E2DCF0318935D823A42452A3310271A870245E34543E5B8CC3A58EAC08891F7B266926A33938C324390F2122" }
            @{ String = $stringToHash; HashType = "SHA512"; HashOutput = "9409155BCA9BECE469DA8161AEDD399621D50C3F94E3EB2DC56BB307DACE711EDCF832FD42BC25767E2DE80D967601B97CF228FB3382009D0A6CAB5DF34D9A92" }
            @{ String = $stringToHash; HashType = "MD5"   ; HashOutput = "9EE1E110CF17B8602F823FD51532F860" }
        )


        It "Should have sane <HashType> output" -TestCases $testCases {

            Param($String, $HashType, $HashOutput)
            $gshArgs = 
            @{ 
                String   = $String
                HashType = $HashType
            }
        
            Get-StringHash @gshArgs | Should -BeExactly $HashOutput
        }
    } # Context
}
