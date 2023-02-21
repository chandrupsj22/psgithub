<#
	.SYNOPSIS
		Executes branching for the Athena Browser projects in BitBucket.
	.DESCRIPTION
		This script branches the Athena Browser projects in BitBucket		
	.PARAMETER release
		The release being created. Examples: 1.1611.1, 1.1612.1
	.Parameter settingsFile
		The path to the ABE_settings.xml
	.Parameter BitbucketUser
		Bitbucket user 
	.Parameter BitbucketPassword
		Bitbucket password
	.EXAMPLE
		Invoke-ABEBranch -release 1.1705.1 -settingsFile C:\settings.xml -BitbucketUser username -BibucketPassword password
#>
function Invoke-ABEBranch
{

Param(
        
        #[Parameter(Mandatory=$true)][string]$settingsFile,
        #[Parameter(Mandatory=$True)][string]$release
        
    )

    # Boilerplate
       
    $ErrorActionPreference = "Stop" #stop on all errors

    #[xml]$settings = Get-Content .\settings.xml
    [xml]$settings = Get-Content "$PSScriptRoot/settings.xml"

    $Auth64Encoded = Get-Base64Auth 

    $GitHub_projects = New-Object System.Collections.ArrayList

    foreach ( $project in $settings.project.components.component ) {
	
	if ($project.project){
	    $project_vars = @{'repo'=$project.name.ToLower();'project'=$project.project}
        $GitHub_projects.add($project_vars) | out-null
	}
	

#Write-Output $GitHubCredentials
#Branching Bitbucket Repos
#Import-Module "PS-Bitbucket"
            $projectJson = ($object.project | ConvertTo-Json )
               $repoJson = ($object.repo | ConvertTo-Json )
 
  foreach ($object in $GitHub_projects){
    #$object = $GitHub_projects
	$fullbranch = "release/$release"
  try {
              if ((Get-Branches -GithubProject $object.project -GithubRepo $object.repo | Where-Object {$_ -like "*$fullbranch*"})) {
				Write-Warning "Branch $fullbranch already exists in $($Object.project)/$($object.repo)."
                
			} else {
  
	Write-Host -NoNewline "Branching" $object.repo "from 'main' to" $fullbranch `n
	
   
          
     New-Branch -GithubProject $object.project -GithubRepo $object.repo -NewBranchName $fullbranch -BranchFrom "main"
     #New-Branch -GithubProject $pj -GithubRepo $rpo -NewBranchName $fullbranch -BranchFrom "main"
    }} Catch {
					 $ErrorMessage = $_.Exception.Message
					 Write-Host "`tFailure with $($object.project)/$($object.repo) $($object.trunkBranch) for $fullbranch"
					 Write-Host "`tError message: $ErrorMessage"
					 $errors += "Failure with $($object.project)/$($object.repo) $($object.trunkBranch) for $fullbranch Error message: $ErrorMessage"
					 Continue
				}
                }
	}
}
