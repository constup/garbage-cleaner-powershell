function Remove-RegistryValue {
    param (
        [Parameter(Mandatory=$true)]
        [string]$registryValue
    )

    $path = Split-Path $registryValue
    $value = Split-Path -Path $registryValue -Leaf
    if ((Test-Path -Path $path) -and ($null -ne (Get-ItemProperty -Path $path -Name $value -ErrorAction SilentlyContinue))) {
        Remove-ItemProperty -Path $path -Name $value
        $totalRemoved += 1
        Write-Host "Removed: $registryValue"

        return $true
    }

    return $false
}