function Get-CurrentUserSteamRegistryKeyPath {
    return @("HKCU:\Software\Valve\Steam", "SteamPath")
}

function Get-LocalMachineSteamRegistryKeyPath {
    return @("HKLM:\SOFTWARE\WOW6432Node\Valve\Steam", "InstallPath")
}

function Find-SteamDirectory {
    $steamRegistryPath = Get-CurrentUserSteamRegistryKeyPath
    $path = $steamRegistryPath[0]
    $key = $steamRegistryPath[1]

    if ((Test-Path -Path "$path") -and ($null -ne (Get-ItemProperty -Path "$path" -Name "$key" -ErrorAction SilentlyContinue)))
    {
        return Get-ItemProperty -Path "$path" -Name "$key" | Select-Object -ExpandProperty "$key"
    } else {
        $steamRegistryPath = Get-LocalMachineSteamRegistryKeyPath
        $path = $steamRegistryPath[0]
        $key = $steamRegistryPath[1]

        if ((Test-Path -Path "$path") -and ($null -ne (Get-ItemProperty -Path "$path" -Name "$key" -ErrorAction SilentlyContinue)))
        {
            return Get-ItemProperty -Path "$path" -Name "$key" | Select-Object -ExpandProperty "$key"
        } else {
            return $null
        }
    }
}