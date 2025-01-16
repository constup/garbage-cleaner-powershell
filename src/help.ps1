function Show-Help {
    $version = Get-Content -Path (Join-Path $PSScriptRoot ../version)
    $helpText = @"
    constUP Garbage Cleaner PowerShell version $version
    License: MPL 2.0 https://www.mozilla.org/en-US/MPL/2.0/
    Minimum required PowerShell version: 7
    ----------
    For full documentation and advanced use guides visit: https://github.com/constup/garbage-cleaner-powershell/blob/master/README.adoc
    ----------
    Usage: pwsh .\constup-garbage-cleaner.ps1 [options...]
    -help                   Print this help.
    -cleanupListFile        Path to cleanup configuration JSON file. Default: `./cleanup-list.json`
    -dryRun                 Run the cleaner without performing cleaning operations to determine size savings.
        -detailed           When added to `-dryRun` it will list the details about what is going to be deleted.
    -clean                  Run the cleaning process. If no optional parameters are provided (listed below) it will clean by all active cleanup rules.
        -applications       Comma separated list of applications which you want to clean
        -categories         Comma separated list of garbage categories which you want to clean
        -entityCategories   Comma separated list of entity categories which you want to clean
        -customCategories   Comma separated list of custom categories which you want to clean
        -types              Comma separated list of types of garbage which you want to clean
    -listActive             List active cleanup rules.
    -listInactive           List inactive cleanup rules.
    -listApplications       View the list of all applications present in the cleanup list file. (example: Firefox, Chrome,...).
    -listCategories         View the list of all categories present in the cleanup file. (example: IDE, browser,...).
    -listEntityCategories   View the list of all entity categories present in the cleanup file. (example: log, crash log,...).
    -listTypes              View the list of all garbage types present in the cleanup file. (example: file, directory,...).
    -listCustomCategories   View the list of all custom categories (which you have defined).
    -listInstructions       View the list of all garbage creation prevention instructions.
    ----------
    Example - detailed dry run:
    $ pwsh .\constup-garbage-cleaner.ps1 -dryRun -detailed
    ---
    Example - clean the system using the default cleanup list:
    $ pwsh .\constup-garbage-cleaner.ps1 -clean
    ---
    Example - clean the system using your own cleanup list:
    $ pwsh .\constup-garbage-cleaner.ps1 -clean -cleanupListFile /path/to/your/cleanup-list.json
    ---
    Example - clean only specific applications:
    $ pwsh .\constup-garbage-cleaner.ps1 -clean -applications "JetBrains,Firefox"
    ---
    Example - clean only specific garbage categories from specific applications:
    $ pwsh .\constup-garbage-cleaner.ps1 -clean -applications "JetBrains,Firefox" -categories "log,crash log"
    ---
    Example - List all active cleanup rules from the default configuration file:
    $ pwsh .\constup-garbage-cleaner.ps1 -listActive
    ---
    Example - List all inactive cleanup rules from your custom configuration file:
    $ pwsh .\constup-garbage-cleaner.ps1 -listInactive -cleanupListFile /path/to/your/cleanup-list.json
    ---------
"@
    Write-Host $helpText
}