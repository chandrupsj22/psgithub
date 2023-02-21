#add the parent directory to the PSModulePath so the current module can be found.
$parentPath = Split-Path -Path $PSScriptRoot -Parent
if ( $env:PSModulePath -NotLike "*$ParentPath*" ) {
	Write-Host "Adding $ParentPath to PSModulePath environment variable..."
	$env:PSModulePath += ";$ParentPath"
}

# Get the local module info
$moduleName = (Get-ChildItem -Path $PSScriptRoot\*.psd1 -Recurse | Split-Path -Leaf).Split(".")[0]
$moduleInfo = Invoke-Expression ((Get-Content "$PSScriptRoot\$moduleName.psd1") -join "`n")

#Import the local module
Import-Module -Name $moduleName -RequiredVersion $moduleInfo.ModuleVersion -Force
Get-Command -Module $moduleName

#Parse the dependencies in the nuspec file and ensure they are loaded
[xml]$spec = Get-Content -Path "$PSScriptRoot\$moduleName.nuspec"
foreach ( $item in $spec.package.metadata.dependencies.dependency ) {
	choco upgrade $item.id -y
}