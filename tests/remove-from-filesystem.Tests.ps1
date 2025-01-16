Describe 'Remove-File' {
    BeforeAll {
        . $PSScriptRoot/../src/remove-from-filesystem.ps1

        Mock Write-Host {
            param($Object)
            $global:actualParameters = $Object
        }
    }

    BeforeEach {
        $testPath = "TestDrive:\sample.txt"
        Set-Content $testPath -Value "lorem ipsum"
    }

    It 'Should delete a file' {
        $realPath = "TestDrive:\sample.txt".Replace('TestDrive:', (Get-PSDrive TestDrive).Root)
        Test-Path -Path "TestDrive:\sample.txt" | Should -BeTrue

        $result = Remove-File -fileName "TestDrive:\sample.txt" -size 1457520

        Should -Invoke Write-Host -Exactly 1
        Should -Invoke Write-Host -Exactly 1 -ParameterFilter { $Object -eq "Removed: $realPath - saved 1457520 bytes (1.39 MB)" }

        Test-Path -Path "TestDrive:\sample.txt" | Should -BeFalse
        $result | Should -BeTrue
    }

    It 'Should return false, because file does not exist' {
        Test-Path -Path "TestDrive:\non_exisiting_sample.txt" | Should -BeFalse

        $result = Remove-File -fileName "TestDrive:\non_existing_sample.txt" -size 1457520
        Should -Not -Invoke Write-Host
        $result | Should -BeFalse
    }
}

Describe 'Remove-Directory' {
    BeforeAll {
        . $PSScriptRoot/../src/remove-from-filesystem.ps1

        Mock Write-Host {
            param($Object)
            $global:actualParameters = $Object
        }
    }

    BeforeEach {
        New-Item -ItemType Directory -Force -Path TestDrive:\sample_directory
        $testPath = "TestDrive:\sample_directory\sample.txt"
        Set-Content $testPath -Value "lorem ipsum"
    }

    It 'Should delete a directory' {
        Test-Path -Path "TestDrive:\sample_directory" | Should -BeTrue

        $result = Remove-Directory -directoryName "TestDrive:\sample_directory" -size 1457520

        Should -Invoke Write-Host -Exactly 1
        Should -Invoke Write-Host -Exactly 1 -ParameterFilter { $Object -eq "Removed: TestDrive:\sample_directory - saved 1457520 bytes (1.39 MB)" }

        Test-Path -Path "TestDrive:\sample_directory" | Should -BeFalse
        $result | Should -BeTrue
    }

    It 'Should return false, because directory does not exist' {
        Test-Path -Path "TestDrive:\non_exisiting_directory" | Should -BeFalse

        $result = Remove-Directory -directoryName "TestDrive:\non_existing_directory" -size 1457520
        Should -Not -Invoke Write-Host
        $result | Should -BeFalse
    }
}