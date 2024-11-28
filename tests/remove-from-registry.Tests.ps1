Describe 'Remove-RegistryValue' {
    BeforeAll {
        . $PSScriptRoot/../src/remove-from-registry.ps1

        Mock Write-Host {
            param($Object)
            $global:actualParameters = $Object
        }
    }

    BeforeEach {
        if (-Not (Test-Path -Path "TestRegistry:\TestLocation"))
        {
            New-Item -Path TestRegistry:\ -Name TestLocation
        }
        New-ItemProperty -Path "TestRegistry:\TestLocation" -Name "TestKey" -Value "sample"

        Test-Path -Path "TestRegistry:\TestLocation" | Should -Be $true
        $value = Get-ItemProperty -Path "TestRegistry:\TestLocation" -Name "TestKey" | Select-Object -ExpandProperty "TestKey"
        $value | Should -Be "sample"
    }

    It 'Should delete registry key' {
        $result = Remove-RegistryValue -registryValue "TestRegistry:\TestLocation\TestKey"
        $result | Should -Be $true

        Test-Path -Path "TestRegistry:\TestLocation" | Should -Be $true
        $result = $null -eq (Get-ItemProperty -Path "TestRegistry:\TestLocation" -Name "TestKey" -ErrorAction SilentlyContinue)
        $result | Should -Be $true
        Should -Invoke Write-Host -Exactly 1
        Should -Invoke Write-Host -Exactly 1 -ParameterFilter { $Object -eq "Removed: TestRegistry:\TestLocation\TestKey" }
    }
}