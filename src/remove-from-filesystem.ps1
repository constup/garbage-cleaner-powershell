function Remove-File {
    param (
        [Parameter(Mandatory=$true)]
        [string]$fileName,
        [Parameter(Mandatory=$true)]
        [int]$size
    )

    if (Test-Path $fileName) {
        $file = Get-Item $fileName
        Remove-Item $fileName
        Write-Host "Removed: $file - saved $size bytes"

        return $true
    }

    return $false
}

function Remove-Directory {
    param (
        [Parameter(Mandatory=$true)]
        [string]$directoryName,
        [Parameter(Mandatory=$true)]
        [int]$size
    )

    if (Test-Path $directoryName) {
        Remove-Item -Path $directoryName -Recurse -Force
        Write-Host "Removed: $directoryName - saved $size bytes"

        return $true
    }

    return $false
}