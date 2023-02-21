<#
    .SYNOPSIS

    Return Base64string

    .DESCRIPTION

    Generates a username:password in base64 string format from a PSCredential object.

    .EXAMPLE
    Get-Base64Auth -Credentials <credential_object>
#>

$ErrorActionPreference = "Stop"

function Get-Base64AuthBitbucket
{
    $Username = "3yXu8kYQ7Cfk4KhKUj"
$Password = "TDY8vVjAUmc3FUT6LDk69qV2fLd9Rugz"
$RefreshToken = "hW4pNP35WgfYNzCgCZ"
$Auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($Username):$($Password)"))
$Body = @{
  client_id = "3yXu8kYQ7Cfk4KhKUj"
  client_secret = "TDY8vVjAUmc3FUT6LDk69qV2fLd9Rugz"
  grant_type = "refresh_token"
  refresh_token = $RefreshToken
}

$output = Invoke-RestMethod -Method POST -Uri "https://bitbucket.org/site/oauth2/access_token" -Headers @{Authorization=("Basic {0}" -f $Auth)} -Body $Body

#Write-Host $output.access_token

    Write-Output $output.access_token            

    #Write-Output $Env:GitHubToken  
  
    
}
