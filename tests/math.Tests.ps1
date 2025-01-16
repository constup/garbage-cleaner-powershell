Describe 'Calculate-Size' {
    BeforeAll {
        . $PSScriptRoot/../src/math.ps1
        Mock Write-Host {}
    }

    It 'Should calculate size in KB.' {
        $result = Calculate-Size -size 1025
        $result | Should -Be "1 KB"

        $result = Calculate-Size -size 1423
        $result | Should -Be "1.39 KB"
    }

    It 'Should calculate size in MB.' {
        $result = Calculate-Size -size 1048577
        $result | Should -Be "1 MB"

        $result = Calculate-Size -size 1457520
        $result | Should -Be "1.39 MB"
    }

    It 'Should calculate size in GB.' {
        $result = Calculate-Size -size 1073741825
        $result | Should -Be "1 GB"

        $result = Calculate-Size -size 1492501135
        $result | Should -Be "1.39 GB"
    }

    It 'Should not calculate anything.' {
        $result = Calculate-Size -size 1023
        $result | Should -Be "1023 B"
    }
}