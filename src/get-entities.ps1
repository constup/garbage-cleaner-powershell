function Get-Entities {
    param (
        [Parameter(Mandatory=$true)]
        [string]$cleanupListFile,
        [string[]]$applications = @(),
        [string[]]$categories = @(),
        [string[]]$entityCategories = @(),
        [string[]]$types = @(),
        [string[]]$customCategories = @()
    )

    $json = Get-Content -Raw $cleanupListFile | ConvertFrom-Json
    $filteredProperties = $json.PSObject.Properties | Where-Object {
        $_.Value.active -eq $true -and
        ($applications.Count -eq 0 -or $applications -contains $_.Value.application) -and
        ($categories.Count -eq 0 -or $categories -contains $_.Value.category) -and
        ($entityCategories.Count -eq 0 -or $entityCategories -contains $_.Value.entity_category) -and
        ($types.Count -eq 0 -or $types -contains $_.Value.delete.type) -and
        ($customCategories.Count -eq 0 -or $customCategories -contains $_.Value.custom_category)
    }

    if ($filteredProperties) {
        $files = New-Object System.Collections.Generic.List[object]
        $directories = New-Object System.Collections.Generic.List[object]
        $registryValues = New-Object System.Collections.Generic.List[object]
        $cleanerErrors = New-Object System.Collections.Generic.List[object]

        $sizeCounter = 0
        $registryCounter = 0

        $filteredProperties | ForEach-Object {
            $location = $_.Value.delete.location
            $name = $_.Name
            switch ($_.Value.delete.type)
            {
                "file" {
                    if (Test-Path -Path $location -PathType Leaf) {
                        $fileItem = @{}
                        $fileItem.location = $location
                        $file = Get-Item $location
                        $fileItem.size = $file.Length
                        $fileItem.rule = $name
                        $files.Add($fileItem)
                        $sizeCounter += 1
                    }
                    elseif (Test-Path -Path $location -PathType Container)
                    {
                        $cleanerErrors.Add("Error in $name : $location is a directory, but is defined in your cleanup list as a file.")
                    }

                    break
                }
                "directory" {
                    if (Test-Path -Path $location -PathType Container) {
                        $directoryItem = @{}
                        $directoryItem.location = $location
                        $size = (Get-ChildItem $location -Recurse | Measure-Object -Property Length -Sum).Sum
                        $directoryItem.size = $size
                        $directoryItem.rule = $name
                        $directories.Add($directoryItem)
                        $sizeCounter += $size
                    }
                    elseif (Test-Path -Path $location -PathType Leaf)
                    {
                        $cleanerErrors.Add("Error in $name : $location is a file, but is defined in your cleanup list as a directory.")
                    }

                    break
                }
                "registry value" {
                    $path = Split-Path $location
                    $value = Split-Path -Path $location -Leaf
                    if (Test-Path -Path $path) {
                        if ($null -ne (Get-ItemProperty -Path $path -Name $value -ErrorAction SilentlyContinue))
                        {
                            $registryValueItem = @{}
                            $registryValueItem.rule = $name
                            $registryValueItem.location = $location
                            $registryValues.Add($registryValueItem)
                            $registryCounter += 1
                        }
                    }

                    break
                }
                "registry key" {
                    if (Test-Path -Path $location) {
                        $registryValueItem = @{}
                        $registryValueItem.rule = $name
                        $items = Get-ItemProperty -Path $location
                        if ($items) {
                            $items.PSObject.Properties | ForEach-Object {
                                $name = $_.Name
                                if ($name -ne "PSPath" -and $name -ne "PSParentPath" -and $name -ne "PSChildName" -and $name -ne "PSDrive" -and $name -ne "PSProvider") {
                                    $location = $location + '\' + $name
                                    $registryValueItem.location = $location
                                    $RegistryValues.Add($registryValueItem)
                                    $registryCounter += 1
                                }
                            }
                        }
                    }

                    break
                }
            }
        }

        if (($files.Count -eq 0) -and ($directories.Count -eq 0) -and ($registryValues.Count -eq 0) -and ($cleanerErrors.Count -eq 0)) {
            return $null
        }

        $result = @{}
        $result.files = $files
        $result.directories = $directories
        $result.registryValues = $registryValues
        $result.cleanerErrors = $cleanerErrors
        $result.totalSize = $sizeCounter
        $result.totalRegistryEntries = $registryCounter

        return $result
    } else {
        Write-Host "There are no active rules."

        return $null
    }
}
