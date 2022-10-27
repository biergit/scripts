param(
    [Parameter(HelpMessage="Your Bitbucket bearer token which you can generate yourself")]
    [string] $bearer,
    [Parameter(HelpMessage="The reviewer name (email)")]
    [string] $reviewer
)
$conf = .\Get-Conf.ps1
$conf.endpoint -match "(https?)(:\/\/)(.*)"
$domain = $Matches.3
$headers = @{Authorization = "Bearer $($conf.bearer)" }
$prs = .\Get-My-PRs.ps1
$prs | Where-Object { !$_.reviewers } | ForEach-Object { 
$body = @"
{
    "id": "$($_.id)",
    "version": $($_.version),
    "reviewers": [
        {
            "user": {
                "name": "$($conf.reviewer)"
            }
        }
    ]
}
"@
$url = $_.links.self.href.Replace($domain,"$domain/rest/api/1.0")
Write-Host Posting $body to $url...
Invoke-RestMethod $url `
-Method Put -Headers $headers -Proxy $($conf.proxy) -Body $body -ContentType "application/json"
}