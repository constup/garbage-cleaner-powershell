$config = New-PesterConfiguration
$config.TestDrive.Enabled = $true
$config.TestRegistry.Enabled = $true
$config.Run.Path = @("./tests", "./tests/applications/steam")
$config.CodeCoverage.RecursePaths = $true
$config.CodeCoverage.Enabled = $true
$config.CodeCoverage.Path = './src'
$config.CodeCoverage.OutputPath = './coverage/coverage.xml'
$config.CodeCoverage.OutputFormat = 'JaCoCo'

Invoke-Pester -Configuration $config