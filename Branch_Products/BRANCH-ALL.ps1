Param(
    [Parameter(Mandatory=$true)][System.Management.Automation.PSCredential]$Credentials
)

Function Update-ChocoModule {
	Param ( [string]$moduleName )

	#verify Chocolatey is installed
	try { choco.exe } catch { iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) }

	$proxy = $env:http_proxy
	$env:http_proxy = ""
	if ( ( Get-Module -ListAvailable).Name -notcontains $moduleName ) {
		choco install $moduleName -y
	} else {
		choco upgrade $moduleName -y
	}
	$env:http_proxy = $proxy
	Import-Module -Name $moduleName
}

$moduleName = "PS-Bitbucket"
Update-ChocoModule $moduleName

. $PSScriptRoot/Branch-AthenaSampleTestDeployer.ps1 -Credentials $Credentials

. $PSScriptRoot/Branch-SDS.ps1 -Credentials $Credentials

. $PSScriptRoot/Branch-ServiceProxy.ps1 -Credentials $Credentials
