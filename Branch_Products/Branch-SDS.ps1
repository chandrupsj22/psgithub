Param(
    [Parameter(Mandatory=$true)][System.Management.Automation.PSCredential]$Credentials,
    [Parameter(Mandatory=$true)][string]$SDSNewVersion
)

Import-Module PS-Bitbucket

New-Branch -Credentials $Credentials -BitbucketProject "PVVS" -BitbucketRepo "softwaredistributionservice" -NewBranchName "release/$SDSNewVersion" -BranchFrom "dev"