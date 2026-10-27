[CmdletBinding()]
param(
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'
$projectRoot = [IO.Path]::GetFullPath($PSScriptRoot)
$filesToPackage = @(
    'app.py',
    'requirements.txt',
    '.env.example',
    'README.md'
)

foreach ($relativePath in $filesToPackage) {
    $sourcePath = Join-Path $projectRoot $relativePath
    if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
        throw "Required package file is missing: $relativePath"
    }
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $OutputPath = Join-Path (Split-Path -Parent $projectRoot) "DataAnalyzer-$timestamp.zip"
}
$archivePath = [IO.Path]::GetFullPath($OutputPath)
if (Test-Path -LiteralPath $archivePath) {
    throw "The output archive already exists: $archivePath"
}

$stagingPath = Join-Path ([IO.Path]::GetTempPath()) (
    'DataAnalyzer-package-' + [guid]::NewGuid().ToString('N')
)
New-Item -ItemType Directory -Path $stagingPath | Out-Null

try {
    foreach ($relativePath in $filesToPackage) {
        Copy-Item -LiteralPath (Join-Path $projectRoot $relativePath) `
            -Destination (Join-Path $stagingPath $relativePath)
    }

    $archiveParent = Split-Path -Parent $archivePath
    if (-not (Test-Path -LiteralPath $archiveParent -PathType Container)) {
        New-Item -ItemType Directory -Path $archiveParent -Force | Out-Null
    }

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [IO.Compression.ZipFile]::CreateFromDirectory(
        $stagingPath,
        $archivePath,
        [IO.Compression.CompressionLevel]::Optimal,
        $false
    )
    Write-Output "Created lightweight submission archive: $archivePath"
}
finally {
    Remove-Item -LiteralPath $stagingPath -Recurse -Force
}
