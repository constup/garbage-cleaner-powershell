. (Join-Path $PSScriptRoot ./prevention-instructions.ps1)

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

function Show-PreventionInstructions {
    param (
        [Parameter(Mandatory=$true)]
        [string]$cleanupListFile
    )

    $result = New-Object System.Collections.Generic.List[object]

    $json = Get-Content -Raw $cleanupListFile | ConvertFrom-Json
    $properties = $json.PsObject.Properties
    $properties | ForEach-Object {
        $instructions = $_.Value.instructions
        if ((-not $result.Contains($instructions)) -and (-not [String]::IsNullOrEmpty($instructions)))
        {
            $item = Add-PreventionInstructions -name $_.Name -location $_.Value.delete.location -instructions $_.Value.instructions
            $result.Add($item)
        }
    }

    return $result
}