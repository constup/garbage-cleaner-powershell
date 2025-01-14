Describe 'ConvertTo-PSObject' {
    BeforeAll {
        $vdfConverterPath = Resolve-Path "$PSScriptRoot\..\..\..\src\applications\steam\vdf-converter.ps1"
        . $vdfConverterPath
    }

    It "Should return a correct PSObject." {
        $vdfContent = Get-Content -Raw "$PSScriptRoot\sample.vdf"
        $expected = Get-Content -Raw "$PSScriptRoot\sample.json" | ConvertFrom-Json | ConvertTo-Json -Depth 100 -Compress

        $result = ConvertTo-PSObject -vdfContent $vdfContent
        $result | Should -BeOfType PSObject

        $resultJson = $result | ConvertTo-Json -Depth 100 -Compress
        $resultJson | Should -Be $expected
    }
}