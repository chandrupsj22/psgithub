Param(
    [Parameter(Mandatory=$true)][System.Management.Automation.PSCredential]$Credentials,
    [Parameter(Mandatory=$true)][string]$ServiceProxyNewVersion
)

Import-Module PS-Bitbucket

New-Branch -Credentials $Credentials -BitbucketProject "PVVS" -BitbucketRepo "serviceproxy" -NewBranchName "release/$ServiceProxyNewVersion" -BranchFrom "dev"