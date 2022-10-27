param(
    [Parameter(HelpMessage="Your Bitbucket bearer token which you can generate yourself")]
    [string] $bearer,
    [Parameter(HelpMessage="Repos to release - expecting an array here e.g. @(""MyProject/My-Repo"")")]
    [array] $repos
)
$conf = .\Get-Conf.ps1
$headers = @{Authorization = "Bearer $($conf.bearer)" }
$repos = $conf.repos
if(!$repos) {
    Write-Host "You need to define ""repos"" for which I should create release PRs"
    exit 1
}
$repos | ForEach-Object { $_ -match "(.*)/(.*)" } | ForEach-Object {
    $project = $matches.1
    $repo = $matches.2
    $url = "$($conf.endpoint)/rest/api/1.0/projects/$($project)/repos/$($repo)/pull-requests"
    $body = @"
{
    "title": "Release",
    "fromRef": {
        "id": "refs/heads/develop",
        "type": "BRANCH",
        "repository": {
            "slug": "$($repo)",
            "project": {
                "key": "$($project)"
            }
        }
    },
    "toRef": {
        "id": "refs/heads/release",
        "type": "BRANCH",
        "repository": {
            "slug": "$($repo)",
            "project": {
                "key": "$($project)"
            }
        }
    }
}
"@
    Write-Host Posting $body to $url...
    Invoke-RestMethod $url `
    -Method Post -Headers $headers -Proxy $($conf.proxy) -Body $body -ContentType "application/json"
}