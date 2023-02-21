<#
    .SYNOPSIS

     Remove a particular branch.

    .DESCRIPTION

    Delete a branch from a repo.

    .EXAMPLE
    Remove-Branch -Username <> -Password <> -Environment <> -Repo <> -BranchName <>
#>


function Set-BranchLock
{
    Param(
        
        [Parameter(Mandatory=$true)][string]$GithubProject,
        [Parameter(Mandatory=$true)][string]$GithubRepo,
        [Parameter(Mandatory=$true)][string]$BranchName
       
    )

    $GithubServer = "https://api.github.com/repos"

    $Auth64Encoded = Get-Base64Auth 
    
   
  $PostBody = [PSCustomObject] @{
  required_pull_request_reviews = @{
  dismiss_stale_reviews = [bool]0
  require_code_owner_reviews = [bool]0
  required_approving_review_count = 0
  }
  required_status_checks= @{
  strict = [bool]0
  contexts = @()
  }
   restrictions = $null
  required_signatures = [bool]0
  enforce_admins = [bool]0
  required_linear_history = [bool]0
  allow_force_pushes =[bool]0
  allow_deletions = [bool]0
  required_conversation_resolution = [bool]0
  lock_branch = [bool]0
}

#Write-Host ($PostBody | ConvertTo-Json )

    
               
        $PostBody1 = ConvertTo-Json $PostBody
        
        $Rest_Url = "https://api.github.com/repos/$GithubProject/$GithubRepo/branches/$BranchName/protection"
        $Request = Invoke-RestMethod -Uri $Rest_Url -Method PUT -Headers @{'Authorization'= "Bearer $Auth64Encoded"} -Body $PostBody1 -ContentType "application/json" -DisableKeepAlive
            
    
}
