. (Join-Path $PSScriptRoot ./math.ps1)

function Remove-File {
    param (
        [Parameter(Mandatory=$true)]
        [string]$fileName,
        [Parameter(Mandatory=$true)]
        [long]$size
    )

    if (Test-Path $fileName) {
        $file = Get-Item $fileName
        $calculatedSize = Calculate-Size -size $size
        Remove-Item $fileName
        Write-Host "Removed: $file - saved $size bytes ($calculatedSize)"

        return $true
    }

    return $false
}

function Remove-Directory {
    param (
        [Parameter(Mandatory=$true)]
        [string]$directoryName,
        [Parameter(Mandatory=$true)]
        [long]$size
    )

    if (Test-Path $directoryName) {
        $calculatedSize = Calculate-Size -size $size
        Remove-Item -Path $directoryName -Recurse -Force
        Write-Host "Removed: $directoryName - saved $size bytes ($calculatedSize)"

        return $true
    }

    return $false
}