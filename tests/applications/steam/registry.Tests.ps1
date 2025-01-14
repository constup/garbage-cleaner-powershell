Describe 'Get-CurrentUserSteamRegistryKeyPath' {
    BeforeAll {
        $registryPath = Resolve-Path "$PSScriptRoot\..\..\..\src\applications\steam\registry.ps1"
        . $registryPath
    }

    It 'Should return registry path and key.' {
        $result = Get-CurrentUserSteamRegistryKeyPath
        $result | Should -Be @("HKCU:\Software\Valve\Steam", "SteamPath")
    }
}

Describe 'Get-LocalMachineSteamRegistryKeyPath' {
    BeforeAll {
        $registryPath = Resolve-Path "$PSScriptRoot\..\..\..\src\applications\steam\registry.ps1"
        . $registryPath
    }

    It 'Should return registry path and key.' {
        $result = Get-LocalMachineSteamRegistryKeyPath
        $result | Should -Be @("HKLM:\SOFTWARE\WOW6432Node\Valve\Steam", "InstallPath")
    }
}

Describe 'Find-SteamDirectory' {
    BeforeAll {
        $registryPath = Resolve-Path "$PSScriptRoot\..\..\..\src\applications\steam\registry.ps1"
        . $registryPath

        Mock Get-CurrentUserSteamRegistryKeyPath {
            return @("TestRegistry:\Software\Valve\Steam", "SteamPath")
        }

        Mock Get-LocalMachineSteamRegistryKeyPath {
            return @("TestRegistry:\SOFTWARE\WOW6432Node\Valve\Steam", "InstallPath")
        }
    }

    Context 'Only HKCU Steam key exists.' {
        BeforeAll {
            New-Item -Force -Path "TestRegistry:\Software\Valve\Steam"
            New-ItemProperty -Path "TestRegistry:\Software\Valve\Steam" -Name "SteamPath" -Value "lorem ipsum"
        }

        It 'Should read from HKCU if it exists.' {
            $result = Find-SteamDirectory
            $result | Should -Be "lorem ipsum"
        }
    }

    Context 'Only HKLM Steam key exists.' {
        BeforeAll {
            New-Item -Force -Path "TestRegistry:\SOFTWARE\WOW6432Node\Valve\Steam"
            New-ItemProperty -Path "TestRegistry:\SOFTWARE\WOW6432Node\Valve\Steam" -Name "InstallPath" -Value "lorem ipsum dolor"
        }
        It 'Should read from HKLM if it exists.' {
            $result = Find-SteamDirectory
            $result | Should -Be "lorem ipsum dolor"
        }
    }

    Context 'Both HKCU and HKLM Steam keys exist.' {
        BeforeAll {
            New-Item -Force -Path "TestRegistry:\Software\Valve\Steam"
            New-ItemProperty -Path "TestRegistry:\Software\Valve\Steam" -Name "SteamPath" -Value "lorem ipsum"

            New-Item -Force -Path "TestRegistry:\SOFTWARE\WOW6432Node\Valve\Steam"
            New-ItemProperty -Path "TestRegistry:\SOFTWARE\WOW6432Node\Valve\Steam" -Name "InstallPath" -Value "lorem ipsum dolor"
        }

        It 'Should read from HKCU if both keys exist' {
            $result = Find-SteamDirectory
            $result | Should -Be "lorem ipsum"
        }
    }

    Context 'Neither HKCU nor HKLM Steam keys exist.' {
        It 'Should return null if neither HKCU nor HKLM Steam key exists.' {
            $result = Find-SteamDirectory
            $result | Should -Be $null
        }
    }
}