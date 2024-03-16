function Show-Applications {
    param (
        [Parameter(Mandatory=$true)]
        [string]$cleanupListFile
    )

    $result = New-Object System.Collections.Generic.List[object]

    $json = Get-Content -Raw $cleanupListFile | ConvertFrom-Json
    $properties = $json.PSObject.Properties
    $properties | ForEach-Object {
        $item = $_.Value.application
        if (-not $result.Contains($item)) {
            $result.Add($item)
        }
    }

    return $result
}

function Show-Categories {
    param (
        [Parameter(Mandatory=$true)]
        [string]$cleanupListFile
    )

    $result = New-Object System.Collections.Generic.List[object]

    $json = Get-Content -Raw $cleanupListFile | ConvertFrom-Json
    $properties = $json.PSObject.Properties
    $properties | ForEach-Object {
        $item = $_.Value.category
        if (-not $result.Contains($item)) {
            $result.Add($item)
        }
    }

    return $result
}

function Show-EntityCategories {
    param (
        [Parameter(Mandatory=$true)]
        [string]$cleanupListFile
    )

    $result = New-Object System.Collections.Generic.List[object]

    $json = Get-Content -Raw $cleanupListFile | ConvertFrom-Json
    $properties = $json.PSObject.Properties
    $properties | ForEach-Object {
        $item = $_.Value.entity_category
        if (-not $result.Contains($item)) {
            $result.Add($item)
        }
    }

    return $result
}

function Show-Types {
    param (
        [Parameter(Mandatory=$true)]
        [string]$cleanupListFile
    )

    $result = New-Object System.Collections.Generic.List[object]

    $json = Get-Content -Raw $cleanupListFile | ConvertFrom-Json
    $properties = $json.PSObject.Properties
    $properties | ForEach-Object {
        $item = $_.Value.delete.type
        if (-not $result.Contains($item)) {
            $result.Add($item)
        }
    }

    return $result
}

function Show-CustomCategories {
    param (
        [Parameter(Mandatory=$true)]
        [string]$cleanupListFile
    )

    $result = New-Object System.Collections.Generic.List[object]

    $json = Get-Content -Raw $cleanupListFile | ConvertFrom-Json
    $properties = $json.PSObject.Properties
    $properties | ForEach-Object {
        $item = $_.Value.custom_category
        if ((-not $result.Contains($item)) -and (-not [String]::IsNullOrEmpty($item))) {
            $result.Add($item)
        }
    }

    return $result
}