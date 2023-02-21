<#
    .SYNOPSIS

    Get all branches of repo.

    .DESCRIPTION

    Given project name and repo name, fetches all branches for that repo.

    .EXAMPLE
    Get-Branches -Username <> -Password <> -Environment <> -Repo <>
#>


function Get-SettingsFile
{
    Param(
        
        [Parameter(Mandatory=$true)][string]$GithubProject,
        [Parameter(Mandatory=$true)][string]$GithubRepo,
        [Parameter(Mandatory=$true)][string]$settingsFile
        
    )

    $Server  = "https://api.github.com/repos"

    $Auth64Encoded = Get-Base64Auth 
    $Rest_Url = "{0}/{1}/{2}/branches" -f $Server,$GithubProject,$GithubRepo
    
    $Request = Invoke-RestMethod -Uri $Rest_Url -Method Get -Headers @{'Authorization'= $Auth64Encoded} -DisableKeepAlive

    if ( !(Test-Path $settingsFile)) { throw "Unable to find settings file! ($settingsFile)" }
        [xml]$settings = Get-Content "$settingsFile"
    
   
    return $settings
}
