param(
    [Parameter(Mandatory,HelpMessage="DAIF-1234: , or something like that")]
    [string] $commitPrefix,
    [Parameter(HelpMessage="Your Bitbucket name")]
    [string] $author,
    [Parameter(HelpMessage="Your Bitbucket bearer token which you can generate yourself")]
    [string] $bearer
    )
$conf = .\Get-Conf.ps1
#Write-Host ($conf | ForEach-Object { $_ | Out-String })
$renovateConf = Get-Content .\renovate-config-template.js -Raw
($renovateConf -replace """username"".*\:.*","""username"": ""$($conf.author)""," `
-replace """password"".*\:.*","""password"": ""$($conf.bearer)""," `
-replace """repositories"".*\:.*", """repositories"": $(ConvertTo-Json $conf.repos)," `
-replace """endpoint"".*\:.*","""endpoint"": ""$($conf.endpoint)""," `
-replace """matchPackageNames"".*\:.*", """matchPackageNames"": $(ConvertTo-Json $conf.packageNames)," `
-replace """registryUrls"".*\:.*", """registryUrls"": $(ConvertTo-Json $conf.registryUrls),") `
| Set-Content .\renovate-config.js
docker run --rm -e RENOVATE_COMMIT_MESSAGE_PREFIX=$commitPrefix -e NODE_TLS_REJECT_UNAUTHORIZED='0' -e LOG_LEVEL=debug -e HTTPS_PROXY=$($conf.proxy) -v $PWD/renovate-config.js:/usr/src/app/config.js -v $env:USERPROFILE/.m2/settings.xml:/usr/src/app/.m2/settings.xml renovate/renovate:slim
