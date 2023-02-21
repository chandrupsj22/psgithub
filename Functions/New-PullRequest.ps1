<#
    .SYNOPSIS

    Create a new pull request

    .DESCRIPTION

    Create a new pull request to be used for merging

    .EXAMPLE
    New-PullRequest -Username <> -Password <> -Environment <> -Repo <> -PullTitle <> -PullDescription <> -FromBranch <> -ToBranch <>
#>


function New-PullRequest
{
    Param(
        
        [Parameter(Mandatory=$true)][string]$GithubProject,
        [Parameter(Mandatory=$true)][string]$GithubRepo,
        [Parameter(Mandatory=$true)][string]$PullTitle,
        [Parameter(Mandatory=$true)][string]$PullDescription,
        [Parameter(Mandatory=$true)][string]$FromBranch,
        [Parameter(Mandatory=$true)][string]$ToBranch
        
    )


    $Server = "https://api.github.com/repos"

    $Auth64Encoded = Get-Base64Auth
   
    $RestUrl = "{0}/{1}/{2}/pulls" -f $Server,$GithubProject,$GithubRepo
    
    $PostBody = @{"title"="$PullTitle";"body"="Please pull these awesome changes in!";"head"="${GithubProject}:$FromBranch";"base"="$ToBranch"}
    
    $JsonPostBody = ConvertTo-Json $PostBody -Depth 5

    $Request = Invoke-RestMethod -Uri $RestUrl -Method Post -Headers @{'Authorization'= "Bearer $Auth64Encoded"} -Body $JsonPostBody -ContentType "application/json" -DisableKeepAlive

    $Request
}