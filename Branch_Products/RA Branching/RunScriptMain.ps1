Remove-Module -Name PS-GitHub
Import-Module -Name PS-GitHub
#----------------------------
Remove-Module -Name ps-bitbucket
Import-Module -Name ps-bitbucket

Get-Module -ListAvailable

[xml]$settings = Get-Content .\settings.xml
$settings.project.components.component | Format-Table -AutoSize
#-------------------------------------------------------------------------------------------
#Script Execution

#Execute the script "Get-Branches"   --Will listout all the branches in current repository--
$GithubProject = $Env:GithubProject
$GithubRepo = $Env:GithubRepo
Get-Branches -GithubProject $GithubProject -GithubRepo $GithubRepo
#-------------------------------------------------------------------------------------------
#Execute the script "Get-BranchPermissions"   --will get all the permissions in branch---
$GithubProject = $Env:GithubProject
$GithubRepo = $Env:GithubRepo
$BranchName = "main"         # <--- Enter your Input inside double quotes-- 
Get-BranchPermissions -GithubProject $GithubProject -GithubRepo $GithubRepo -BranchName $BranchName
#-------------------------------------------------------------------------------------------
#Execute the script "Get-Commits"   --will get all the commits done in the repo---
$GithubProject = $Env:GithubProject
$GithubRepo = $Env:GithubRepo
Get-Commits -GithubProject $GithubProject -GithubRepo $GithubRepo 
#-------------------------------------------------------------------------------------------
#Execute the script "Get-Hook"   --will get specific webhook information---
$GithubProject = $Env:GithubProject
$GithubRepo = $Env:GithubRepo
$HookKey = "395105442"         # <--- Enter your Input inside double quotes-- (run the script "Get-Hooks" to get to know "id" or "HookKey" value.)
Get-Hook -GithubProject $GithubProject -GithubRepo $GithubRepo -HookKey $HookKey
#-------------------------------------------------------------------------------------------
#Execute the script "Get-Hooks"   --will list all the webhooks available in the repo---
$GithubProject = $Env:GithubProject
$GithubRepo = $Env:GithubRepo
Get-Hooks -GithubProject $GithubProject -GithubRepo $GithubRepo
#-------------------------------------------------------------------------------------------
#Execute the script "Get-HookSettings"   --will get URL for the specific webhook---
$GithubProject = $Env:GithubProject
$GithubRepo = $Env:GithubRepo
$HookKey = "395105442"          # <--- Enter your Input inside double quotes-- (run the script "Get-Hooks" to get "id" or "HookKey" value.)
Get-HookSettings -GithubProject $GithubProject -GithubRepo $GithubRepo -HookKey $HookKey
#-------------------------------------------------------------------------------------------
#Execute the script "Get-SettingsFile"   --will check XML file exist or not---
$GithubProject = $Env:GithubProject
$GithubRepo = $Env:GithubRepo
$settingsFile = "C:\Users\chand\OneDrive\Documents\WindowsPowerShell\Modules\PS-GitHub\Branch_Products\RA Branching\settings.xml"          # <--- Enter your Input inside double quotes (Complete path of local xml file. eg.. "C:\Users\..\..\settings.xml")
Get-SettingsFile -GithubProject $GithubProject -GithubRepo $GithubRepo -settingsFile $settingsFile
#-------------------------------------------------------------------------------------------
#Execute the script "New-PullRequest"   --will initiate new pull request---
$GithubProject = $Env:GithubProject
$GithubRepo = $Env:GithubRepo
$PullTitle  = "script pull"      # <--- Enter your Input inside double quotes
$PullDescription = "script pull" # <--- Enter your Input inside double quotes
$FromBranch = "new1"             # <--- Enter your Input inside double quotes
$ToBranch   = "main"             # <--- Enter your Input inside double quotes
New-PullRequest -GithubProject $GithubProject -GithubRepo $GithubRepo -PullTitle $PullTitle -PullDescription $PullDescription -FromBranch $FromBranch -ToBranch $ToBranch
#-------------------------------------------------------------------------------------------
#Execute the script "Invoke-BranchMerge"   --will merge branches based on pull request---
$GithubProject = $Env:GithubProject
$GithubRepo = $Env:GithubRepo
$FromBranch = "new1"          # <--- Enter your Input inside double quotes
$ToBranch   = "main"          # <--- Enter your Input inside double quotes
Invoke-BranchMerge -GithubProject $GithubProject -GithubRepo $GithubRepo -FromBranch $FromBranch -ToBranch $ToBranch
#-------------------------------------------------------------------------------------------
#Execute the script "New-Branch"   --will create new branch---
$GithubProject = $Env:GithubProject
$GithubRepo = "rebase"
$NewBranchName = "new131"    # <--- Enter your Input inside double quotes
$BranchFrom   = "main"     # <--- Enter your Input inside double quotes
New-Branch -GithubProject $GithubProject -GithubRepo $GithubRepo -NewBranchName $NewBranchName -BranchFrom $BranchFrom
#-------------------------------------------------------------------------------------------

#Execute the script "Remove-Branch"   --will remove specific branch---
$GithubProject = $Env:GithubProject
$GithubRepo = $Env:GithubRepo
$BranchName = "new1"          # <--- Enter your Input inside double quotes
Remove-Branch -GithubProject $GithubProject -GithubRepo $GithubRepo -BranchName $BranchName
#-------------------------------------------------------------------------------------------
#Execute the script "Set-BranchLock"   --will allow you to protect branches from pull or merge request (to perform this, need to change values inside "Set-BranchLock". eg.lock_branch = [bool]1 ---> <[bool]1> is for 'true' and <[bool]0> is for 'false'
$GithubProject = $Env:GithubProject
$GithubRepo = $Env:GithubRepo
$BranchName = "main"          # <--- Enter your Input inside double quotes
Set-BranchLock -GithubProject $GithubProject -GithubRepo $GithubRepo -BranchName $BranchName
#---------------------------------------------------------------------------------------
#Execute the script "Invoke-ABEBranch"   --will create release branch if XML condition satisfied---
$GithubProject = $Env:GithubProject
$GithubRepo = $Env:GithubRepo
$release = ""          # <--- Enter your Input inside double quotes
Invoke-ABEBranch -release $release
#-------------------------------------------------------------------------------------------

#--MAIN SCRIPT---

#                                        

#Execute the script "Create-RABranch1"  --look for an RA2 flag for the component in the settings.xml.If this flag exists, it will create two branches, one for release/xxxx from the dev-ra1 branch and one for release/2.xxxx from the dev branch
$GithubProject = $Env:GithubProject
$GithubRepo = $Env:GithubRepo
$release = "8.3"          # <--- Enter your Input inside double quotes
.\Create-RABranch1.ps1 -release $release

#-------------------------------------------------------------------------------------------

# Config Environment variable--------

Get-ChildItem Env:

# $Env:<variable-name> = "<new-value>"

$Env:GithubProject = ""
$Env:GithubRepo = ""
$Env:BranchSha = "3fc12e0a340462dffa9cb0afb20e8fa7b01c7b62"     #---> New-Branch
$Env:GitHubToken


Invoke-ABEBranch  ---comment settingfile at function parameter

#-------------------------------------------------------------------------------------------

#To use powershell 7 on windows powershell ISE

#1. run this script "C:\Users\...\RA Branching\powershell 7 switch.ps1"
#2. choose "SwitchToPowershell" from Add-ons Menu.


#-------------------------------------------------------------------------------------------
[xml]$settings = Get-Content .\settings.xml
$settings.project.components.component | Format-Table -AutoSize

#-------------------------------------------------------
$GithubProject = $Env:GithubProject
$GithubRepo = $Env:GithubRepo
$release = "2"          # <--- Enter your Input inside double quotes
.\MainTestMultiBranchOut.ps1 -release $release

#-----------------------------
BITBUCKET
#-----------------------------
Bitbucket token: rdOjrBoNA4k9SwHc8y1n
NewBranch script
$BitbucketProject = "chandrunandha"
$BitbucketRepo = "testrepo123"
$NewBranchName = "new110"    # <--- Enter your Input inside double quotes
$BranchFrom   = "master"     # <--- Enter your Input inside double quotes
New-BranchBitbucket -BitbucketProject $BitbucketProject -BitbucketRepo $BitbucketRepo -NewBranchName $NewBranchName -BranchFrom $BranchFrom
#------------------------------------------------------------------------------------------------------------------------------------------------
GetBranch - Bitbucket
$BitbucketProject = "chandrunandha"
$BitbucketRepo = "BitbucketTestRepo"
Get-BranchesBitbucket -BitbucketProject $BitbucketProject -BitbucketRepo $BitbucketRepo 
#----------------------------------------------------------------------------------------------------------------------
$release = "8.2.3"          # <--- Enter your Input inside double quotes
.\Create-RABranchBitbucket.ps1 -release $release


Remove-Module -Name PS-Bitbucket
Import-Module -Name PS-Bitbucket

Remove-Module -Name PS-GitHub
Import-Module -Name PS-GitHub

$release = "16"          # <--- Enter your Input inside double quotes
.\Create-RABranch1.ps1 -release $release

$release = "217"          # <--- Enter your Input inside double quotes
.\Create-RABranchBitbucket.ps1 -release $release