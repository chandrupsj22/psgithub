<#
    .SYNOPSIS

    Get all branches of repo.

    .DESCRIPTION

    Given project name and repo name, fetches all branches for that repo.

    .EXAMPLE
    Get-Branches -Username <> -Password <> -Environment <> -Repo <>
#>


function Get-BranchPermissions
{
    Param(
        
        [Parameter(Mandatory=$true)][string]$GithubProject,
        [Parameter(Mandatory=$true)][string]$GithubRepo,
        [Parameter(Mandatory=$true)][string]$BranchName
        
    )

    $Server  = "https://api.github.com/repos"

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $Auth64Encoded = Get-Base64Auth 

    $Rest_Url = "{0}/{1}/{2}/branches/{3}/protection" -f $Server,$GithubProject,$GithubRepo,$BranchName
    #$Rest_Url = "https://api.github.com/repos/$GithubProject/$GithubRepo/branches/$BranchName/protection"
    $Request = Invoke-RestMethod -Uri $Rest_Url -Method Get -Headers @{'Authorization'= "Bearer $Auth64Encoded"} -DisableKeepAlive
    $Request
    
}