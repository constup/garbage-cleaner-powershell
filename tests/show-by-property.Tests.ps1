Describe 'Show-Applications' {
    BeforeAll {
        . $PSScriptRoot/../src/show-by-property.ps1
    }

    It 'Should display a list of all applications' {
        $expected = New-Object System.Collections.Generic.List[object]
        $expected.AddRange(@("JetBrains", "Gradio", "WSL", "Viber", "Delphi", "Windows", ".NET", "Scoop"))
        $expected = $expected | Sort-Object

        $result = Show-Applications -cleanupListFile $PSScriptRoot/cleanup-list.tests-sample.json
        $result | Should -BeExactly $expected
    }

    It 'Should display a list of all categories' {
        $expected = New-Object System.Collections.Generic.List[object]
        $expected.AddRange(@("IDE", "AI", "Windows", "communication", ".NET", "installer"))
        $expected = $expected | Sort-Object

        $result = Show-Categories -cleanupListFile $PSScriptRoot/cleanup-list.tests-sample.json
        $result | Should -BeExactly $expected
    }

    It 'Should display a list of all entity categories' {
        $expected = New-Object System.Collections.Generic.List[object]
        $expected.AddRange(@("crash log", "temporary files", "log", "telemetry", "cache"))
        $expected = $expected | Sort-Object

        $result = Show-EntityCategories -cleanupListFile $PSScriptRoot/cleanup-list.tests-sample.json
        $result | Should -BeExactly $expected
    }

    It 'Should display a list of all types' {
        $expected = New-Object System.Collections.Generic.List[object]
        $expected.AddRange(@("file", "directory"))
        $expected = $expected | Sort-Object

        $result = Show-Types -cleanupListFile $PSScriptRoot/cleanup-list.tests-sample.json
        $result | Should -BeExactly $expected
    }

    It 'Should display a list of all custom categories' {
        $expected = New-Object System.Collections.Generic.List[object]
        $expected.AddRange(@())

        $result = Show-CustomCategories -cleanupListFile $PSScriptRoot/cleanup-list.tests-sample.json
        $result | Should -BeExactly $expected
    }
}