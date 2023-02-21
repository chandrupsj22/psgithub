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

#function Create-RABranch1
#{

Param(
        
        #[Parameter(Mandatory=$True)][string]$release
        
    )
	
		#$secPassword = ConvertTo-SecureString "mypassword" -AsPlainText -Force
        #$credential = New-Object System.Management.Automation.PSCredential ("chandrupsj22", $secPassword)
		#[switch]$bitbucketonly,
		$useLocalSettingsFile
		#[switch]$noModuleUpgrades
	    
		
	
	
	if ($useLocalSettingsFile) {
		
		if (!(Test-Path "$PSScriptRoot/settings.xml")) {
			Write-Error -Message "You choose to use the local settings but the file does not exist in the folder." -ErrorAction Stop
		}
	}

	#Write-Debug "Create Changespec and Branchspec for Perforce"

	# Boilerplate
	#$ErrorActionPreference = "Stop" #stop on all errors
	#$branchName = "RA_" + $release
	[xml]$settings = Get-Content "$PSScriptRoot/settings.xml"


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

	
	Write-Host "Branching bitbucket"

	#Branching Bitbucket Repos
	#Import-Module "PS-bitbucket"
	foreach ($object in $bitbucket_projects){
		if ($object.ra2) {
        	$fullbranch= "release/2.$release"
            }
            elseif($object.ra3){
        	$fullbranch="release/3.$release"
        }
        else{
        	$fullbranch="release/$release"
        }
            try {     
                     if ((Get-BranchesBitbucket -BitbucketProject $object.project -BitbucketRepo $object.repo | Where-Object {$_ -like "*$fullbranch*"})) {
				Write-Warning "Branch $fullbranch already exists in $($Object.project)/$($object.repo)."
                Write-Host -NoNewline "----------------------------------------------------------------------------" `n
			} else {
				Write-Host -NoNewline "Branching $($object.project)/$($object.repo) from $($object.trunkBranch) to " $fullbranch `n 
				
				
                          	
                        Write-Host -NoNewline "Branching" $object.repo "from 'main' to" $fullbranch `n
                        
                       
			       New-BranchBitbucket -BitbucketProject $object.project -BitbucketRepo $object.repo -NewBranchName $fullbranch -BranchFrom $trunkBranch
      Write-Host -NoNewline "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------<<< $($object.repo) >>>" `n
                   
                }

            } Catch {
			$ErrorMessage = $_.Exception.Message
			Write-Host "`tFailure with $($object.project)/$($object.repo) $($object.trunkBranch)"
			Write-Host "`tError message: $ErrorMessage"
			$errors += "Failure with $($object.project)/$($object.repo) $($object.trunkBranch) Error message: $ErrorMessage"
			Continue			
		}
    }
       

	Write-Host "bitbucket Code branch complete for $release"
	


