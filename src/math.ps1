function Calculate-Size {
    param (
        [Parameter(Mandatory=$true)]
        [long]$size
    )

    if ($size -ge 1GB) {
        $result = [math]::Round($size / 1GB, 2)
        return "$result GB"
    } elseif ($size -ge 1MB) {
        $result = [math]::Round($size / 1MB, 2)
        return "$result MB"
    }
    elseif ($size -ge 1KB) {
        $result = [math]::Round($size / 1KB, 2)
        return "$result KB"
    }
    else {
        return "$size B"
    }
}