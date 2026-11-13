# Dot-source this script: . .\scripts\dev-shell.ps1
# Activates Node 22 for the current PowerShell session only.
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$nodeVersion = (Get-Content -LiteralPath (Join-Path $projectRoot '.node-version') -Raw).Trim()
if ($nodeVersion -notmatch '^22\.\d+\.\d+$') {
    throw 'Expected a pinned Node.js 22 version in .node-version.'
}
$runtimeRoot = Join-Path $env:LOCALAPPDATA 'mdd-dev\node'
$runtimeName = "node-v$nodeVersion-win-x64"
$runtimePath = Join-Path $runtimeRoot $runtimeName
$nodeExe = Join-Path $runtimePath 'node.exe'

if (-not (Test-Path -LiteralPath $nodeExe)) {
    New-Item -ItemType Directory -Path $runtimeRoot -Force | Out-Null
    $archiveName = "$runtimeName.zip"
    $archivePath = Join-Path $runtimeRoot $archiveName
    $downloadRoot = "https://nodejs.org/dist/v$nodeVersion"
    Write-Host "Installing Node.js $nodeVersion in $runtimeRoot"
    Invoke-WebRequest -UseBasicParsing -Uri "$downloadRoot/$archiveName" -OutFile $archivePath
    $checksums = (Invoke-WebRequest -UseBasicParsing -Uri "$downloadRoot/SHASUMS256.txt").Content
    $checksumLine = ($checksums -split "`n" | Where-Object { $_.Trim().EndsWith(" $archiveName") })
    if (-not $checksumLine) { throw 'Archive checksum not found.' }
    $expectedHash = ($checksumLine.Trim() -split '\s+')[0]
    $actualHash = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash
    if ($actualHash -ne $expectedHash) { throw 'Node.js archive checksum mismatch.' }
    Expand-Archive -LiteralPath $archivePath -DestinationPath $runtimeRoot -Force
    Remove-Item -LiteralPath $archivePath
}

$env:Path = "$runtimePath;$env:Path"
Write-Host "Node.js $(& $nodeExe --version) active in this terminal."
Write-Host 'Available: npm ci, npm run db:up, npm run dev'
