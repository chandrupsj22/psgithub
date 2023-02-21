$Auth64Encoded = "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"

$repositories = @("GitHubTestRepo", "rebase", "Java")

foreach ($repo in $repositories) {
$shavalue = (Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/chandrupsj22/$repo/git/refs/heads/main" -Headers @{'Authorization'= "Bearer $Auth64Encoded"}).object.sha

$PostBody = @{
                      "ref" = "refs/heads/branch22"
                      "sha" = $shavalue
                     }
    #Invoke-RestMethod -Uri "https://api.github.com/repos/chandrupsj22/$repo/git/refs" -Method POST -ContentType 'application/json' -Headers @{Authorization = "token $token"} -Body ('{"ref": "refs/heads/newbranch11","sha": $shavalue}')

    $PostBody1 = ConvertTo-Json $PostBody
        
        $Rest_Url = "https://api.github.com/repos/chandrupsj22/$repo/git/refs"
        
        $Request = Invoke-RestMethod -Uri $Rest_Url -Method POST -Headers @{'Authorization'= "Bearer $Auth64Encoded"} -Body $PostBody1 -ContentType "application/json" -DisableKeepAlive 
        
        

        Write-Output "New Branch Created:($Request).ref"
}