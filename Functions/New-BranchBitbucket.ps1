<#
    .SYNOPSIS

    Creates a new branch.

    .DESCRIPTION

    Creates a new branch from an exsisting branch. Requires the name of the branch to branch from.

    .EXAMPLE
    New-Branch -Username <> -Password <> -Environment <> -Repo <> -BranchName <> -BrachFrom <>
#>

function New-BranchBitbucket
{

Param(
        
        [Parameter(Mandatory=$true)][string]$BitbucketProject,
        [Parameter(Mandatory=$true)][string]$BitbucketRepo,
        [Parameter(Mandatory=$true)][string]$NewBranchName,
        [Parameter(Mandatory=$true)][string]$BranchFrom
        
        
    )

    #Write-Host "Checking existing branches, via New-Branch function"
    #$ExistingBranches = Get-Branches -GithubProject $GithubProject -GithubRepo $GithubRepo
     
     
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        
                               
        $Auth64Encoded1 = Get-Base64AuthBitbucket 
        
        
        #$shavalue = (Invoke-RestMethod -Method Get -Uri "https://api.bitbucket.org/2.0/repositories/chandrunandha/BitbucketTestRepo/refs/branches/$BranchFrom").target.hash
        $shavalue = (Invoke-RestMethod -Method Get -Uri "https://api.bitbucket.org/2.0/repositories/$BitbucketProject/$BitbucketRepo/refs/branches/$BranchFrom").target.hash
         $body = @{
                    "name" = $NewBranchName
          "target" = @{
                    "hash" = $shavalue
                      }
                  }

           $json = $body | ConvertTo-Json
           $headers = @{
           "Authorization" = "Bearer $Auth64Encoded1"
                       }
          #$Rest_Url = "https://api.bitbucket.org/2.0/repositories/chandrunandha/BitbucketTestRepo/refs/branches"
          $Rest_Url = "https://api.bitbucket.org/2.0/repositories/$BitbucketProject/$BitbucketRepo/refs/branches"

          $response = Invoke-RestMethod -Method POST -Uri $Rest_Url -Headers $headers -Body $json -ContentType "application/json" -DisableKeepAlive
        
        

        Write-Output "New Branch Created:($response).ref"
        
    }
 