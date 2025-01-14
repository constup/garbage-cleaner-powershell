function Get-LibraryFoldersVdf {
    . (Join-Path $PSScriptRoot ./registry.ps1)

    $location = "/config/libraryfolders.vdf"
    $oldLocation = "/steamapps/libraryfolders.vdf"

    $steamDirectory = Find-SteamDirectory

    $locationExists = Test-Path -Path "$steamDirectory$location"
    if ($locationExists) {
        $result = Get-Content -Raw "$steamDirectory$location"
    } else {
        $locationExists = Test-Path -Path "$steamDirectory$oldLocation"
        if ($locationExists) {
            $result = Get-Content -Raw "$steamDirectory$oldLocation"
        } else {
            return $null
        }
    }

    return $result
}