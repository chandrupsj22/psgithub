<#
    .SYNOPSIS

    Get all branches of repo.

    .DESCRIPTION

    Given project name and repo name, fetches all branches for that repo.

    .EXAMPLE
    Get-Branches -Username <> -Password <> -Environment <> -Repo <>
#>


function Get-BranchesBitbucket
{
    Param(
        
        [Parameter(Mandatory=$true)][string]$BitbucketProject,
        [Parameter(Mandatory=$true)][string]$BitbucketRepo
    )

    #$Server  = "https://api.github.com/repos"

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $Auth64Encoded1 = Get-Base64AuthBitbucket
    $headers = @{
           "Authorization" = "Bearer $Auth64Encoded1"
                }
    
    #$Rest_Url = "{0}/{1}/{2}/git/refs/heads" -f $Server,$GithubProject,$GithubRepo
    $Rest_Url = "https://api.bitbucket.org/2.0/repositories/$BitbucketProject/$BitbucketRepo/refs/branches"
    
    $Request = Invoke-RestMethod -Uri $Rest_Url -Method Get -Headers $headers  -DisableKeepAlive

    
   ($Request).values.name
}