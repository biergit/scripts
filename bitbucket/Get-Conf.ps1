param(
[hashtable]
$vars
)
if($vars) {
    $notProvidedConcat = ($vars.Keys | Where-Object {!$vars[$_] }) -join ","
}
Write-Host "Parameters not provided via command line: $notProvidedConcat - Checking bitbucket.conf file..."
if($notProvidedConcat -or !$vars) {
    try {
        $conf = Get-Content .\bitbucket.conf -Raw -ErrorAction Stop | ConvertFrom-JSON
    }
    catch {
        Write-Host "An error occurred. You did not provide value(s) for ""$notProvidedConcat"" so I tried to read it from a JSON file ""bitbucket.conf"" `
        in your current directory which failed."
        Write-Host $_
        Write-Host $_.ScriptStackTrace
        exit 1
    } 
}
foreach ($key in $vars.keys) {
    if($vars[$key]) {
        $conf["$key"] = $vars[$key]
    }
}
$conf    
