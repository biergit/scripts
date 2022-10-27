param(
    [Parameter(HelpMessage="Your Bitbucket bearer token which you can generate yourself")]
    [string] $bearer
)
$conf = .\Get-Conf.ps1
$conf.endpoint -match "(https?)(:\/\/)(.*)"
$domain = $Matches.3
$headers = @{Authorization = "Bearer $($conf.bearer)" }
$prs = .\Get-My-PRs.ps1
$prs | Where-Object { $_.reviewers[0].approved } | ForEach-Object { 
$url = "$($_.links.self.href.Replace(""$domain"",""$dommain/rest/api/1.0""))/merge?version=$($_.version)"
Write-Host Posting to $url...
Invoke-RestMethod $url `
-Method Post -Headers $headers -Proxy $($conf.proxy) -Body $body -ContentType "application/json"
}