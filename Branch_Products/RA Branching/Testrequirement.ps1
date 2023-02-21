
# Set the path to the XML file
$xmlFile = "C:\Users\chand\OneDrive\Documents\WindowsPowerShell\Modules\PS-GitHub\Branch_Products\RA Branching\settings.xml"

# Load the XML file into an object
$xml = [xml](Get-Content $xmlFile)

# Get all of the component names from the XML file
$componentNames = $xml.project.components.component.name

# Loop through each component name
foreach ($componentName in $componentNames) {
   
   # Set the repository name based on the component name
   $repoName = $componentName

   # Set the access token for the GitHub API
   $accessToken = "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"

   # Set the headers for the API call
   $headers = @{
       "Authorization" = "Token $accessToken"
             
   }
   
   $sha = (Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/chandrupsj22/$repoName/git/refs/heads/dev").object.sha

   #$Request = Invoke-RestMethod -Uri $Rest_Url -Method Get -Headers @{'Authorization'= "Bearer $Auth64Encoded"}  -DisableKeepAlive
   $body = @{
    "ref" = "refs/heads/release"
    "sha" = $sha
}

   # Set the base URL for the API call
   $baseUrl = "https://api.github.com/repos/chandrupsj22/$repoName"

   $PostBody = ConvertTo-Json $body

   # Create the release branch
   $response = Invoke-RestMethod -Method POST -Uri "$baseUrl/git/refs" -Headers $headers -Body $PostBody -ContentType "application/json" -DisableKeepAlive
   
   # Output the status of the release branch creation
   if ($response.ref -contains "refs/heads/release") {
       Write-Host "Successfully created release branch for $repoName repository"
   } else {
       Write-Host "Failed to create release branch for $repoName repository"
   }
}

     




