<#
	.SYNOPSIS
		Executes branching for the PVP repositories in BitBucket.
	.DESCRIPTION
		This script branches the PVP repositories in BitBucket		
	.PARAMETER release
		The release being created. Examples: 1.18.6, 1.18.8...
	.Parameter repos
		The array of repository names
	.Parameter publisherCore_branch
		The publishercore branch name
	.Parameter Project
		Bitbucket project name
	.Parameter BitbucketUser
		Bitbucket user 
	.Parameter BitbucketPassword
		Bitbucket password 
	.EXAMPLE
		Invoke-PVPBranch -publisherCore_branch 1.38 -release 1.18.10 -BitbucketUser username -BibucketPassword password
#>
function Invoke-PVPBranch
{

Param (
	$repos=@('Publisher','PublisherCore','PublisherHub','PublisherProxy'),

	$project='PUBLISHER',

	[Parameter(Mandatory=$True)][string]$publisherCore_branch,
	
	[Parameter(Mandatory=$True)][string]$release,

	[Parameter(Mandatory=$true)][string]$GithubUser,

    [Parameter(Mandatory=$true)][string]$GithubPassword

)

# Boilerplate
$GithubPass = ConvertTo-SecureString -String $GithubPassword -AsPlainText -Force
$GithubCredentials = New-Object System.Management.Automation.PSCredential ($GithubUser,$GithubPass)
$ErrorActionPreference = "Stop" #stop on all errors

$fullbranch = "release/$release"
Write-Host "Full branch name is $fullbranch."
#Write-Output $BitbucketCredentials
#Branching Bitbucket Repos
	foreach ($element in $repos)
	{
		#Get existing repo branches
		Write-Host "Getting existing branches."
		$ExistingBranches = Get-Branches -Credentials $GithubCredentials -GithubProject $project -GithubRepo $element
		
		if (($element -eq 'PublisherCore') -and ($ExistingBranches -notcontains "refs/heads/r$publisherCore_branch"))
		{
			Write-Host -NoNewline "Branching" $element "from 'main' to r$publisherCore_branch" `n
			New-Branch -Credentials $GithubCredentials -GithubProject $project -GithubRepo $element -NewBranchName "r$publisherCore_branch" -BranchFrom "main"
		}
		elseif(($element -ne 'PublisherCore') -and ($ExistingBranches -notcontains "refs/heads/$fullbranch"))
		{
			Write-Host -NoNewline "Branching" $element "from 'dev' to" $fullbranch `n
			New-Branch -Credentials $GithubCredentials -GithubProject $project -GithubRepo $element -NewBranchName $fullbranch -BranchFrom "dev"
		}
		else
		{
			Write-Host "Branch already exists for $element, skipping"
		}
	}
}