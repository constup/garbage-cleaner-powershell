function Print-Size {
    param (
        [Parameter(Mandatory=$true)]
        [long]$size
    )

    if ($size -gt 1024*1024*1024) {
        $size = $size / 1GB
        Write-Host "Total space saved: $size GB"
    }
    elseif ($size -gt 1024*1024) {
        $size = $size / 1MB
        Write-Host "Total space saved: $size MB"
    } elseif ($size -gt 1024) {
        $size = $size / 1KB
        Write-Host "Total space saved: $size KB"
    }
}