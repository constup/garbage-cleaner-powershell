Describe 'Display-Size' {
    BeforeAll {
        . $PSScriptRoot/../src/math.ps1
        Mock Write-Host {}
    }

    It 'Should display size in KB.' {
        Display-Size -size 1025

        Should -Invoke Write-Host -Exactly 1
        Should -Invoke Write-Host -Exactly 1 -ParameterFilter { $Object -eq "Total space saved: 1 KB" }
    }

    It 'Should display size in MB.' {
        Display-Size -size 1048577

        Should -Invoke Write-Host -Exactly 1
        Should -Invoke Write-Host -Exactly 1 -ParameterFilter { $Object -eq "Total space saved: 1 MB" }
    }

    It 'Should display size in GB.' {
        Display-Size -size 1073741825

        Should -Invoke Write-Host -Exactly 1
        Should -Invoke Write-Host -Exactly 1 -ParameterFilter { $Object -eq "Total space saved: 1 GB" }
    }

    It 'Should not display anything.' {
        Display-Size -size 1023

        Should -Not -Invoke Write-Host
    }
}