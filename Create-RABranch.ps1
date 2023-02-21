#Requires -Version 5

<#
	.SYNOPSIS
		Executes branching for the Reference Architecture projects
	.DESCRIPTION
		This script branches the Reference Architecture Projects in Perforce and Bitbucket 
        Script updated on 8/8/2018 to look for an RA2 flag for the component in the settings.xml.
        If this flag exists, it will create two branches, one for release/xxxx from the dev-ra1 branch
        and one for release/2.xxxx from the dev branch.
		
	.PARAMETER release
		The release being created. Examples: 1409, 1410, 1411
		
	.EXAMPLE
		.\Create-RABranch.ps1 -release 1912 -bitbucketonly -useLocalSettingsFile
#>
#function Create-RABranch (){
	Param (
		[Parameter(Mandatory=$True)][string]$release,
		[Parameter(Mandatory=$true)][System.Management.Automation.PSCredential]$BitbucketCredentials,
		[switch]$bitbucketonly,
		[switch]$useLocalSettingsFile,
		[switch]$noModuleUpgrades
	)
	
	$errors=@()
	
	if (($noModuleUpgrades)) {
		#Check if PS-Perforce and PS-Bitbucket modules are available
		if ( (Get-Module -ListAvailable).Name -notcontains "PS-Bitbucket"){
			choco.exe install "PS-Bitbucket" -y
		}
		else{
			choco.exe upgrade "PS-Bitbucket" -y
		}
	}
	# Collect settings.xml from Perforce //Software/source/misc/scripts/RA/main/settings.xml -- CML 02/28/2017
	if ($useLocalSettingsFile) {
		
		if (!(Test-Path "$PSScriptRoot/settings.xml")) {
			Write-Error -Message "You chose to use the local settings but the file does not exist in the folder." -ErrorAction Stop
		}
	}

	#Write-Debug "Create Changespec and Branchspec for Perforce"

	# Boilerplate
	$ErrorActionPreference = "Stop" #stop on all errors
	#$branchName = "RA_" + $release
	[xml]$settings = Get-Content "$PSScriptRoot/settings.xml"
<#
		# Define new changespec
		$changeSpec = @()
		$changeSpec += "Change:`tnew"
		$changeSpec += "Description:"
		$changeSpec += "`tReference Architecture Branch $release"
		$changeSpec += "Files:"

		# Create new branch
		$branchSpec = @()
		$branchSpec += "Branch:`t" + $branchName + "`r"
		$branchSpec += "Owner:`tTeamCity`r"
		$branchSpec += "Description:`tReference Architecture Branch " + $release + ".`r"
		$branchSpec += "Options:`tunlocked`r"
		$branchSpec += "View:`r"
		$branchSpec += "`t//software/source/misc/scripts/RA/main/... //software/source/misc/scripts/RA/release/" + $release + "/...`r"
#>

		$bitbucket_projects = New-Object System.Collections.ArrayList

		Write-Debug "Collect project information for Bitbucket."
		foreach ( $project in $settings.project.components.component ) {

			if ($project.sourcetype -eq 'bitbucket')
			{
                $trunkBranch="dev"
                # For RA2 projects, need to branch both RA1 and RA2 versions until RA1 version is retired
				if($project.ra2){
					$project_vars = @{'repo'=$project.name.ToLower();'project'=$project.project;'trunkBranch'=$trunkBranch;'ra2'='true';}
					$bitbucket_projects.add($project_vars)
                    $trunkBranch="dev-ra1"
                    $project_vars = @{'repo'=$project.name.ToLower();'project'=$project.project;'trunkBranch'=$trunkBranch;}
					$bitbucket_projects.add($project_vars)
                }
				elseif($project.ra2only){
					$project_vars = @{'repo'=$project.name.ToLower();'project'=$project.project;'trunkBranch'=$trunkBranch;'ra2'='true';}
					$bitbucket_projects.add($project_vars)
				}
                #this special exception is being made for CAS, it's pretty gross while we transition away from cas 2.0
                #will use ra3 to branch cas configs and ra3only to branch code
                #CAS configs dev-> release/2.x and dev -> release/3.x
				elseif($project.ra3){
					$project_vars = @{'repo'=$project.name.ToLower();'project'=$project.project;'trunkBranch'=$trunkBranch;'ra3'='true';}
					$bitbucket_projects.add($project_vars)
                    $project_vars = @{'repo'=$project.name.ToLower();'project'=$project.project;'trunkBranch'=$trunkBranch;'ra2'='true'}
					$bitbucket_projects.add($project_vars)
				}
                #will use ra3only to branch CAS source
                #CAS source dev -> release/3/x and dev-maint -> release/2.x
				elseif($project.ra3only){
					$project_vars = @{'repo'=$project.name.ToLower();'project'=$project.project;'trunkBranch'=$trunkBranch;'ra3'='true';}
					$bitbucket_projects.add($project_vars)
                    $trunkBranch="dev-maint"
                    $project_vars = @{'repo'=$project.name.ToLower();'project'=$project.project;'trunkBranch'=$trunkBranch;'ra2'='true'}
					$bitbucket_projects.add($project_vars)
				}
                else{
                	$project_vars = @{'repo'=$project.name.ToLower();'project'=$project.project;'trunkBranch'=$trunkBranch;}
					$bitbucket_projects.add($project_vars)
                }
                
			}
		}

	if (!$bitbucketonly) {

		<#Write-Debug "Create Changelist for $branchName and apply it to Perforce."

		#Create defined Perforce changelist
		$result = $changeSpec | &P4 change -i
		$changelist = $result.Split(" ")[1]

		if ($result -notlike "Change * created.") { throw "Error creating changelist!" } else { Write-Host "Changelist $changelist created!" }

		$result = $branchSpec | &P4 branch -i
		if ( $result -ne "Branch " + $branchName + " saved." ) {
			Write-Host $result
			throw "Error creating branch specification!"
		} else {
			Write-Host "Created branch specification: "$branchName
		}

		# Create new files in Perforce branch
		&P4 copy -b $branchName -c $changelist
		Write-Host "Created fileset in new branch location..."

		# Submit newly branched files to Perforce
		$result = &p4 submit -c $changelist
		if ( $result -like "Change $changelist * submitted." ) {
			Write-Host "Branch created! (Changelist# $changelist"
		} else {
			$result | Out-File .\submit.txt -Force
			throw "Error submitting changelist #$changelist. See .\submit.txt for full error!"
		}#>
	}
	#}


	Write-Host "Branching Bitbucket"

	#Branching Bitbucket Repos
	Import-Module "PS-Bitbucket"
	foreach ($object in $bitbucket_projects){
		if ($object.ra2) {
        	$fullbranch="release/2.$release"
        }
        elseif($object.ra3){
        	$fullbranch="release/3.$release"
        }
        else{
        	$fullbranch="release/$release"
        }
        Try {
			if ((Get-Branches -Credentials $BitbucketCredentials -BitbucketProject $object.project -BitbucketRepo $object.repo | Where-Object {$_ -like "*$fullbranch*"})) {
				Write-Warning "Branch $fullbranch already exists in $($Object.project)/$($object.repo)."
			} else {
				Write-Host -NoNewline "Branching $($object.project)/$($object.repo) from $($object.trunkBranch) to " $fullbranch `n 
				Write-Debug "Debug pause before creating, $fullbranch"
				Try{
					New-Branch -Credentials $BitbucketCredentials -BitbucketProject $object.project -BitbucketRepo $object.repo -NewBranchName $fullbranch -BranchFrom $object.trunkBranch
				} Catch {
					 $ErrorMessage = $_.Exception.Message
					 Write-Host "`tFailure with $($object.project)/$($object.repo) $($object.trunkBranch) for $fullbranch"
					 Write-Host "`tError message: $ErrorMessage"
					 $errors += "Failure with $($object.project)/$($object.repo) $($object.trunkBranch) for $fullbranch Error message: $ErrorMessage"
					 Continue
				}
			}
		} Catch {
			$ErrorMessage = $_.Exception.Message
			Write-Host "`tFailure with $($object.project)/$($object.repo) $($object.trunkBranch)"
			Write-Host "`tError message: $ErrorMessage"
			$errors += "Failure with $($object.project)/$($object.repo) $($object.trunkBranch) Error message: $ErrorMessage"
			Continue			
		}
	}

	Write-Host "Code branch complete for $release"
	
if ($errors.Count -ne 0){
    Write-Host ""
    Write-Host $errors.Count "error(s) detected,"
    $errors | Format-Table -AutoSize

} else {
    Write-Host ""
    Write-Host "No errors detected."
}
	

#}
