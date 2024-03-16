function Show-Rules {
    param (
        [Parameter(Mandatory=$true)]
        [Boolean]$isActive,
        [Parameter(Mandatory=$true)]
        [String]$cleanupListFile
    )
    $json = Get-Content -Raw $cleanupListFile | ConvertFrom-Json
    $filteredProperties = $json.PSObject.Properties | Where-Object { $_.Value.active -eq $isActive }

    if ($filteredProperties) {
        $filteredProperties | ForEach-Object {
            Write-Host $_.Value.description
            $type = $_.Value.delete.type
            $location = $_.Value.delete.location
            Write-Host "    What will be deleted: $type"
            Write-Host "    Location: $location"
        }
    } else {
        $activeState = $isActive -eq $true ? "active" : "inactive"
        Write-Host "There are no $activeState rules."
    }
}