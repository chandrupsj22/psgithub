# Set client ID and secret
$clientId = "abc028634873fb1a1828"
$clientSecret = "8c374963e1689d75f1dd4f77da3902eaed4dfaa3"
$scope = "user,repo,gist"
$redirectUrl = "https://github.com"

# Build code request URL
$codeUrl = "https://github.com/login/oauth/authorize?client_id=$clientId&scope=$scope&redirect_uri=$redirectUrl"

# Open code request URL in default browser
Start-Process $codeUrl


#Invoke-Expression $codeUrl

# Prompt the user to enter the authorization code
$authCode = Read-Host "Enter the authorization code: "

# Define the access token request URL
$accessTokenRequest = "https://github.com/login/oauth/access_token?client_id=$clientID&client_secret=$clientSecret&code=$authCode"


# Get the access token from the API provider
#$accessToken = (Invoke-WebRequest -Method POST -Uri $accessTokenRequest).Content.Split("&")[0].Split("=")[1]
$response = Invoke-WebRequest -Uri $accessTokenRequest -Method Post -Body $requestBody -ContentType "application/x-www-form-urlencoded" -UseBasicParsing

# Define the authorization header
$authorization = "Token $accessToken"

# Use the access token and authorization header in your API requests
# ...







<# Ask user for code
$code = Read-Host "Enter code from redirect URL"

# Build access token request URL
$tokenUrl = "https://github.com/login/oauth/access_token"
$requestBody = "client_id=$clientId&client_secret=$clientSecret&code=$code&redirect_uri=$redirectUrl&scope=$scope"

# Send POST request to access token URL
$response = Invoke-WebRequest -Uri $tokenUrl -Method Post -Body $requestBody -ContentType "application/x-www-form-urlencoded" -UseBasicParsing

# Extract access token from response
$accessToken = ($response.Content | ConvertFrom-Json).access_token

# Print access token
Write-Host "Access token: $accessToken"#>