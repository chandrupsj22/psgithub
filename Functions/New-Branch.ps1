<#
    .SYNOPSIS

    Creates a new branch.

    .DESCRIPTION

    Creates a new branch from an exsisting branch. Requires the name of the branch to branch from.

    .EXAMPLE
    New-Branch -Username <> -Password <> -Environment <> -Repo <> -BranchName <> -BrachFrom <>
#>

function New-Branch
{

Param(
        
        [Parameter(Mandatory=$true)][string]$GithubProject,
        [Parameter(Mandatory=$true)][string]$GithubRepo,
        [Parameter(Mandatory=$true)][string]$NewBranchName,
        [Parameter(Mandatory=$true)][string]$BranchFrom
        
        
    )

    Write-Host "Checking existing branches, via New-Branch function"
    $ExistingBranches = Get-Branches -GithubProject $GithubProject -GithubRepo $GithubRepo
     
     
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    if($ExistingBranches -contains "refs/heads/$BranchFrom") 
    {
                           
        $Auth64Encoded = Get-Base64Auth 
        #-------------------------------------------------------------------------------------

        $shavalue = (Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/$GithubProject/$GithubRepo/git/refs/heads/$BranchFrom").object.sha
        
   
                      $PostBody = @{
                      "ref" = "refs/heads/$NewBranchName"
                      "sha" = $shavalue
                     }
        #---------------------------------------------------------------------------------------
        #$PostBody = @{"ref"="refs/heads/$NewBranchName";"sha"=$Env:BranchSha}
                
               
        $PostBody1 = ConvertTo-Json $PostBody
        
        $Rest_Url = "https://api.github.com/repos/$GithubProject/$GithubRepo/git/refs"
        
        $Request = Invoke-RestMethod -Uri $Rest_Url -Method POST -Headers @{'Authorization'= "Bearer $Auth64Encoded"} -Body $PostBody1 -ContentType "application/json" -DisableKeepAlive 
        
        

        Write-Output "New Branch Created:($Request).ref"
        
    }
    else{
        throw "Source Branch not found"
    }
}