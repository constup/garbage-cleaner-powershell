$newPath = $PSScriptRoot
$envPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($envPath -notlike "*;$newPath;*" -and $envPath -notlike "$newPath;*" -and $envPath -notlike "*;$newPath") {
    $envPath += ";$newPath"
    [Environment]::SetEnvironmentVariable("Path", $envPath, "User")
    Write-Host "constUP Garbage Cleaner directory $newPath added to your user's PATH environment variable."
} else {
    Write-Host "Nothing to do - constUP Garbage Cleaner is already in you user's PATH environment variable."
}
