function Add-PreventionInstructions {
    param (
        [Parameter(Mandatory=$true)]
        [string]$name,
        [Parameter(Mandatory=$true)]
        [string]$location,
        [Parameter(Mandatory=$true)]
        [string]$instructions
    )

    $preventionInstructionsItem = @{}
    $preventionInstructionsItem.name = $name
    $preventionInstructionsItem.location = $location
    $preventionInstructionsItem.instructions = $instructions

    return $preventionInstructionsItem
}

function Write-PreventionInstructions {
    param(
        [Parameter(Mandatory=$true)]
        [array]$preventionInstructions
    )

    if ($preventionInstructions.Count -ne 0) {
        Write-Host "===Helpful info==="
        Write-Host "Some useful information on how to prevent creation of garbage files which were found on your system:"
        Write-Host "----------"
        $preventionInstructions | ForEach-Object {
            Write-Host "Rule name: $($_.name)"
            Write-Host "Location: $($_.location)"
            Write-Host "Prevention instructions: $($_.instructions)"
            Write-Host "----------"
        }
    }
}