Param(
    [Parameter(Mandatory=$true)][System.Management.Automation.PSCredential]$Credentials,
    [Parameter(Mandatory=$true)][string]$AthenSampleTestNewVersion
)

Import-Module PS-GitHub

New-Branch -Credentials $Credentials -BitbucketProject "ABE" -BitbucketRepo "athenasampletestdeployer" -NewBranchName "release/$AthenSampleTestNewVersion" -BranchFrom "dev"