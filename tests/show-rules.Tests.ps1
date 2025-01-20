Describe 'Show-Rules' {
    BeforeAll {
        . (Resolve-Path "$PSScriptRoot/../src/show-rules.ps1")
    }

    Context 'There is at least one rule to display.' {
        BeforeAll {
            Mock Get-Content {
                return @'
{
    "sample_rule_1": {
        "active": true,
        "description": "Rule 1",
        "delete": {
            "type": "file",
            "location": "C:\\path\\to\\file1"
        }
    },
    "sample_rule_2": {
        "active": false,
        "description": "Rule 2",
        "delete": {
            "type": "directory",
            "location": "C:\\path\\to\\folder2"
        }
    }
}
'@
            }
        }

        It 'should display active rules' {
            Mock Write-Host { }

            Show-Rules -isActive $true -cleanupListFile "mock.json"

            Should -Invoke Write-Host -Exactly 3
            Should -Invoke Write-Host -Exactly 1 -ParameterFilter { $Object -eq "Rule 1" }
            Should -Invoke Write-Host -Exactly 1 -ParameterFilter { $Object -eq "    What will be deleted: file" }
            Should -Invoke Write-Host -Exactly 1 -ParameterFilter { $Object -eq "    Location: C:\path\to\file1" }
        }

        It 'should display inactive rules' {
            Mock Write-Host { }

            Show-Rules -isActive $false -cleanupListFile "mock.json"

            Should -Invoke Write-Host -Exactly 3
            Should -Invoke Write-Host -Exactly 1 -ParameterFilter { $Object -eq "Rule 2" }
            Should -Invoke Write-Host -Exactly 1 -ParameterFilter { $Object -eq "    What will be deleted: directory" }
            Should -Invoke Write-Host -Exactly 1 -ParameterFilter { $Object -eq "    Location: C:\path\to\folder2" }
        }
    }

    Context 'There are no active rules to display' {
        BeforeAll {
            Mock Get-Content {
                return @'
{
    "sample_rule_2": {
        "active": false,
        "description": "Rule 2",
        "delete": {
            "type": "directory",
            "location": "C:\\path\\to\\folder2"
        }
    }
}
'@
            }
        }

        It 'should display that there are no active rules' {
            Mock Write-Host { }

            Show-Rules -isActive $true -cleanupListFile "mock.json"

            Should -Invoke Write-Host -Exactly 1
            Should -Invoke Write-Host -Exactly 1 -ParameterFilter { $Object -eq "There are no active rules." }
        }
    }

    Context 'There are no inactive rules to display' {
        BeforeAll {
            Mock Get-Content {
                return @'
{
    "sample_rule_1": {
        "active": true,
        "description": "Rule 1",
        "delete": {
            "type": "file",
            "location": "C:\\path\\to\\file1"
        }
    }
}
'@
            }
        }

        It 'should display that there are no inactive rules' {
            Mock Write-Host { }

            Show-Rules -isActive $false -cleanupListFile "mock.json"

            Should -Invoke Write-Host -Exactly 1
            Should -Invoke Write-Host -Exactly 1 -ParameterFilter { $Object -eq "There are no inactive rules." }
        }
    }
}