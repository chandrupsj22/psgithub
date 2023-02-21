<#
    .SYNOPSIS

    Get all branches of repo.

    .DESCRIPTION

    Given project name and repo name, fetches all branches for that repo.

    .EXAMPLE
    Get-Branches -Username <> -Password <> -Environment <> -Repo <>
#>


function Get-Hook
{
    Param(
        
        [Parameter(Mandatory=$true)][string]$GithubProject,
        [Parameter(Mandatory=$true)][string]$GithubRepo,
        [Parameter(Mandatory=$true)][string]$HookKey
        
    )

    $Server  = "https://api.github.com/repos"
    

    #[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $Auth64Encoded = Get-Base64Auth 

    $Rest_Url = "{0}/{1}/{2}/hooks/{3}" -f $Server,$GithubProject,$GithubRepo,$HookKey
    #$Rest_Url = "https://api.github.com/repos/$GithubProject/$GithubRepo/hooks/$HookKey"
    $Request = Invoke-RestMethod -Uri $Rest_Url -Method Get -Headers @{'Authorization'= "Bearer $Auth64Encoded"} -DisableKeepAlive

    Write-Output $Request
}