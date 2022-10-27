param(
    [Parameter(HelpMessage="Your Bitbucket bearer token which you can generate yourself")]
    [string] $bearer
)
$conf = .\Get-Conf.ps1
$headers = @{Authorization = "Bearer $($conf.bearer)" }
$result = Invoke-RestMethod "$($conf.endpoint)/rest/api/1.0/dashboard/pull-requests?role=AUTHOR&state=OPEN" -Headers $headers -Proxy $($conf.proxy)
$result.values