$config = New-PesterConfiguration
$config.Run.Path = "./tests"
$config.CodeCoverage.Enabled = $true
$config.CodeCoverage.Path = './src'
$config.CodeCoverage.OutputPath = './coverage/coverage.xml'

Invoke-Pester -Configuration $config