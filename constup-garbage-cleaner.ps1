param (
    $cleanupListFile = (Join-Path $PSScriptRoot ./cleanup-list.json),
    [switch]$clean,
    # list active rules
    [switch]$listActive,
    # list inactive rules
    [switch]$listInactive,
    # print help
    [switch]$help,
    # cleaning filters
    [Parameter(Mandatory=$false)]
    [string[]]$applications = @(),
    [Parameter(Mandatory=$false)]
    [string[]]$categories = @(),
    [Parameter(Mandatory=$false)]
    [string[]]$entityCategories = @(),
    [Parameter(Mandatory=$false)]
    [string[]]$types = @(),
    [Parameter(Mandatory=$false)]
    [string[]]$customCategories = @(),
    # show application, categories, entity categories,...
    [switch]$listApplications,
    [switch]$listCategories,
    [switch]$listEntityCategories,
    [switch]$listTypes,
    [switch]$listCustomCategories,
    # dry run
    [switch]$dryRun,
    [switch]$detailed
)

. (Join-Path $PSScriptRoot ./src/help.ps1)
. (Join-Path $PSScriptRoot ./src/show-rules.ps1)
. (Join-Path $PSScriptRoot ./src/show-by-property.ps1)
. (Join-Path $PSScriptRoot ./src/remove-from-filesystem.ps1)
. (Join-Path $PSScriptRoot ./src/remove-from-registry.ps1)
. (Join-Path $PSScriptRoot ./src/math.ps1)
. (Join-Path $PSScriptRoot ./src/get-entities.ps1)

if ($help) {
    Show-Help
    exit 0
}

if (Test-Path $cleanupListFile)
{
    if ($listActive)
    {
        Show-Rules $true $cleanupListFile
        exit 0
    }
    elseif ($listInactive)
    {
        Show-Rules $false $cleanupListFile
        exit 0
    }
    elseif ($listApplications)
    {
        Write-Host 'Applications from your cleanup rules:'
        $result = Show-Applications($cleanupListFile)
        foreach ($item in $result)
        {
            Write-Host $item
        }
        exit 0
    }
    elseif ($listCategories)
    {
        Write-Host 'Categories from your cleanup rules:'
        $result = Show-Categories($cleanupListFile)
        foreach ($item in $result)
        {
            Write-Host $item
        }
        exit 0
    }
    elseif ($listEntityCategories)
    {
        Write-Host 'Entity categories from your cleanup rules:'
        $result = Show-EntityCategories($cleanupListFile)
        foreach ($item in $result)
        {
            Write-Host $item
        }
        exit 0
    }
    elseif ($listTypes)
    {
        Write-Host 'Cleanup item types from your cleanup rules:'
        $result = Show-Types($cleanupListFile)
        foreach ($item in $result)
        {
            Write-Host $item
        }
        exit 0
    }
    elseif ($listCustomCategories)
    {
        Write-Host 'Custom categories from your cleanup rules:'
        $result = Show-CustomCategories($cleanupListFile)
        foreach ($item in $result)
        {
            Write-Host $item
        }
        exit 0
    }
    elseif ($dryRun)
    {
        $entities = Get-Entities -cleanupListFile $cleanupListFile -applications $applications -categories $categories -entityCategories $entityCategories -types $types -customCategories $customCategories

        $version = Get-Content -Path (Join-Path $PSScriptRoot ./version)
        Write-Host "constUP Garbage Cleaner $version - dry run"

        if ($null -eq $entities)
        {
            Write-Host "Nothing to do."

            exit 0
        }
        else
        {
            if ($detailed) {
                $files = $entities.files
                if ($files.Count -ne 0) {
                    Write-Host '===Files==='
                    foreach ($fileItem in $files) {
                        $rule = $fileItem.rule
                        $location = $fileItem.location
                        $size = $fileItem.size

                        Write-Host $rule
                        Write-Host "    Location: $location"
                        Write-Host "    Size: $size"
                    }
                } else {
                    Write-Host "There are no files to delete."
                }
                Write-Host '----------'

                $directories = $entities.directories
                if ($directories.Count -ne 0) {
                    Write-Host '===Directories==='
                    foreach ($directoryItem in $directories) {
                        $rule = $directoryItem.rule
                        $location = $directoryItem.location
                        $size = $directoryItem.size

                        Write-Host $rule
                        Write-Host "    Location: $location"
                        Write-Host "    Size: $size"
                    }
                } else {
                    Write-Host "There are no directories to delete."
                }
                Write-Host '----------'

                $registryValues = $entities.registryValues
                if ($registryValues.Count -ne 0) {
                    Write-Host '===Registry values==='
                    foreach ($registryValueItem in $registryValues) {
                        $rule = $registryValueItem.rule
                        $location = $registryValueItem.location

                        Write-Host $rule
                        Write-Host "    Location: $location"
                    }
                } else {
                    Write-Host "There are no registry values to delete."
                }
                Write-Host "----------"
            }

            $size = $entities.totalSize
            $registryEntries = $entities.totalRegistryEntries
            Write-Host 'Dry run summary:'
            Write-Host '----------'
            Print-Size($size)
            Write-Host "Total space which would be saved (in exact bytes): $size."
            Write-Host "Total registry entries to delete: $registryEntries"
            Write-Host "----------"
            $cleanerErrors = $entities.cleanerErrors
            if ($cleanerErrors) {
                Write-Host '===Errors==='
                Write-Host "Note: Size calculations do not take into account entries with errors."
                Write-Host "The following errors were found in your cleanup list configuration file:"
                Write-Host "---"
                foreach ($cleanerError in $cleanerErrors) {
                    Write-Host $cleanerError
                }
            }

            exit 0
        }
    } elseif ($clean)
    {
        $version = Get-Content -Path (Join-Path $PSScriptRoot ./version)
        Write-Host "constUP Garbage Cleaner $version"

        $applications = $applications -split ','
        $categories = $categories -split ','
        $entityCategories = $entityCategories -split ','
        $types = $types -split ','
        $customCategories = $customCategories -split ','

        $entities = Get-Entities -cleanupListFile $cleanupListFile -applications $applications -categories $categories -entityCategories $entityCategories -types $types -customCategories $customCategories

        if ($null -eq $entities) {
            Write-Host "Nothing to do."

            exit 0
        }
        else {
            $totalSize = 0

            Write-Host '===Files==='
            $files = $entities.files
            if ($files.Count -ne 0) {
                foreach ($fileItem in $files)
                {
                    $fileName = $fileItem.location
                    $size = $fileItem.size
                    $isCleaned = Remove-File -fileName $fileName -size $size
                    if ($isCleaned) {
                        $totalSize += $size
                    }
                }
                Write-Host '----------'
            } else {
                Write-Host 'No files to clean.'
                Write-Host '----------'
            }

            Write-Host '===Directories==='
            $directories = $entities.directories
            if ($directories.Count -ne 0) {
                foreach ($directoryItem in $directories)
                {
                    $directoryName = $directoryItem.location
                    $size = $directoryItem.size
                    $isCleaned = Remove-Directory -directoryName $directoryName -size $size
                    if ($isCleaned) {
                        $totalSize += $size
                    }
                }
                Write-Host '----------'
            } else {
                Write-Host 'No directories to clean.'
                Write-Host '----------'
            }

            $totalRegistryEntries = 0

            Write-Host '===Registry values==='
            $registryValues = $entities.registryValues
            if ($registryValues.Count -ne 0) {
                foreach ($item in $registryValues) {
                    $location = $item.location
                    $isCleaned = Remove-RegistryValue($location)
                    if ($isCleaned) {
                        $totalRegistryEntries += 1
                    }
                }
                Write-Host '----------'
            } else {
                Write-Host 'No registry values to clean.'
                Write-Host '----------'
            }

            Write-Host '===Errors==='
            $cleanerErrors = $entities.cleanerErrors
            if ($cleanerErrors) {
                foreach ($cleanerError in $cleanerErrors) {
                    Write-Host $cleanerError
                }
                Write-Host '----------'
            } else {
                Write-Host 'No errors in your cleanup list configuration.'
                Write-Host '----------'
            }

            Print-Size($totalSize)
            Write-Host "Total space saved (in exact bytes): $totalSize."
            Write-Host "Total registry entries deleted: $totalRegistryEntries."
        }

        exit 0
    }
} else {
    Write-Host "File $cleanupListFile does not exist."
    exit 1
}

exit 0