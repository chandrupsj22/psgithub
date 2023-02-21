<#
    .SYNOPSIS

     Remove a particular branch.

    .DESCRIPTION

    Delete a branch from a repo.

    .EXAMPLE
    Remove-Branch -Username <> -Password <> -Environment <> -Repo <> -BranchName <>
#>


function Remove-Branch
{
    Param(
        
        [Parameter(Mandatory=$true)][string]$GithubProject,
        [Parameter(Mandatory=$true)][string]$GithubRepo,
        [Parameter(Mandatory=$true)][string]$BranchName
        
    )

    $GithubServer = "https://api.github.com/repos"

    $Auth64Encoded = Get-Base64Auth 

   
   $PostBody = @{"ref"="refs/heads/$BranchName";"dryRun"="false"}

               
        $PostBody1 = ConvertTo-Json $PostBody

        #$Rest_Url = "{0}/{1}/{2}/'git/refs/heads'/{3}" -f $Server,$GithubProject,$GithubRepo,$BranchName

        $Rest_Url = "https://api.github.com/repos/$GithubProject/$GithubRepo/git/refs/heads/$BranchName"
        $Request = Invoke-RestMethod -Uri $Rest_Url -Method DELETE -Headers @{'Authorization'= "Bearer $Auth64Encoded"} -DisableKeepAlive
            
    $Request
    Write-Output "$BranchName <---Branch Removed"
}
