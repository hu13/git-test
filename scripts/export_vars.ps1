
$ErrorActionPreference = 'Stop'
function Get-ScriptDirectory
{
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    Split-Path $Invocation.MyCommand.Path
}

if (Test-Path 'Env:/VERSION_PATH') {
    $VersionInfoFilePath = $env:VERSION_PATH
} else {
    $VersionInfoFilePath = (Get-ScriptDirectory) + '/version_lock.json'
}

$VersionInfo = Get-Content -Path $VersionInfoFilePath | ConvertFrom-Json

$ComponentToKeyMap = @{
    "daemons" = "DAEMONS_HEAD_COMMIT";
    "drive" = "DRIVE_HEAD_COMMIT";
    "updater" = "UPDATER_HEAD_COMMIT";
    "key_menu" = "KEY_MENU_HEAD_COMMIT";
    "findersync" = "FINDERSYNC_HEAD_COMMIT";
    "web" = "PREVEIL_WEB_HEAD_COMMIT";
    "log_exporter" = "LOG_EXPORTER_HEAD_COMMIT";
}

$Output = ""

for ($i = 0 ; $i -lt $VersionInfo.components.length ; $i++) {
    if ($IsWindows) {
        $Output += "Set-Item -Path Env:/$($ComponentToKeyMap[$VersionInfo.components[$i].name]) -Value $($VersionInfo.components[$i].revision)";
    } else {
        $Output += "export $($ComponentToKeyMap[$VersionInfo.components[$i].name])=$($VersionInfo.components[$i].revision)"
    }

    $Output += "`n"
}
if ($IsWindows) {
    $Output += "Set-Item -Path Env:/VERSION -Value $($VersionInfo.version)"
} else {
    $Output += "export VERSION=$($VersionInfo.version)"
}

Write-Output $Output
