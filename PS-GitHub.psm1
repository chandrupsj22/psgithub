# Load all of the functions
Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 | Where-Object { $_.Name -notLike "*.Tests.ps1" } | Foreach-Object{ . $_.FullName }

# Export all commands except for Test-ElevatedShell
Export-ModuleMember -Function @(Get-Command -Module $ExecutionContext.SessionState.Module)