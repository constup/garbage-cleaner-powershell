Describe 'Get-LibraryFoldersVdf' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\applications\steam\registry.ps1")
        . (Resolve-Path "$PSScriptRoot\..\..\..\src\applications\steam\config-files.ps1")

        Mock Find-SteamDirectory {
            return "TestDrive:\steamdir"
        }
    }

    Context "Only default file is present." {
        BeforeAll {
            New-Item -ItemType Directory -Force -Path TestDrive:\steamdir\config
            $location = "TestDrive:\steamdir\config\libraryfolders.vdf"
            $content = "lorem ipsum"
            Set-Content $location -Value $content
        }

        It 'Should return file contents when default location is used.' {
            $result = Get-LibraryFoldersVdf
            $result | Should -Be "$content`r`n"
        }
    }

    Context "Only old file is present." {
        BeforeAll {
            New-Item -ItemType Directory -Force -Path TestDrive:\steamdir\steamapps
            $location = "TestDrive:\steamdir\steamapps\libraryfolders.vdf"
            $content = "lorem ipsum"
            Set-Content $location -Value $content
        }

        It 'Should return file contents when old location is used.' {
            Test-Path -Path "TestDrive:\steamdir\config\libraryfolders.vdf" | Should -BeFalse
            $result = Get-LibraryFoldersVdf
            $result | Should -Be "$content`r`n"
        }
    }

    Context "Both files are present." {
        BeforeAll {
            New-Item -ItemType Directory -Force -Path TestDrive:\steamdir\config
            $location = "TestDrive:\steamdir\config\libraryfolders.vdf"
            $content = "config lorem ipsum"
            Set-Content $location -Value $content

            New-Item -ItemType Directory -Force -Path TestDrive:\steamdir\steamapps
            $oldLocation = "TestDrive:\steamdir\steamapps\libraryfolders.vdf"
            $oldContent = "steamapps lorem ipsum"
            Set-Content $oldLocation -Value $oldContent
        }

        It "Should return file contents from the config directory if both config and steamapps file exist." {
            $result = Get-LibraryFoldersVdf
            $result | Should -Be "$content`r`n"
        }
    }

    Context "File does not exist in both locations." {
        It 'Should return null if the file was not found.' {
            $result = Get-LibraryFoldersVdf
            $result | Should -Be $null
        }
    }
}