<#
    .SYNOPSIS

    Merge two branches

    .DESCRIPTION

    Merge two branches within same repo or different repo.

    .EXAMPLE
    Get-Branches -Username <> -Password <> -Environment <> -Repo <>
#>


function Invoke-BranchMerge
{
    Param(
        
        [Parameter(Mandatory=$true)][string]$GithubProject,
        [Parameter(Mandatory=$true)][string]$GithubRepo,
        [Parameter(Mandatory=$true)][string]$FromBranch,
        [Parameter(Mandatory=$true)][string]$ToBranch
        
    )


    $Server = "https://api.github.com/repos"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $Auth64Encoded = Get-Base64Auth 
   
    
    #$Rest_Url = "https://api.github.com/repos/chandrupsj22/GitHubTestRepo/merges"

    $Rest_Url = "{0}/{1}/{2}/merges" -f $Server,$GithubProject,$GithubRepo
    #$Request = Invoke-RestMethod -Uri $Rest_Url -Method Get -Headers @{'Authorization'= $Auth64Encoded} -DisableKeepAlive
   
   
                           
        $PostBody = @{"base"=$ToBranch;"head"=$FromBranch;"commit_message"="Shipped cool_feature!"}
        $JsonPostBody = ConvertTo-Json $PostBody
        $Request = Invoke-RestMethod -Uri $Rest_Url -Method POST -Headers @{'Authorization'= "Bearer $Auth64Encoded"} -Body $JsonPostBody -ContentType "application/json" -DisableKeepAlive
    

    Write-Output $Request
}
