# Genera el APK indicando el entorno (dev/prod) e incrementa automáticamente
# el build number (+N) en pubspec.yaml antes de compilar.
#
# Uso:
#   .\scripts\build_apk.ps1 -Flavor dev
#   .\scripts\build_apk.ps1 -Flavor prod
#
# Argumentos extra para "fvm flutter build apk" se pueden agregar al final:
#   .\scripts\build_apk.ps1 -Flavor dev -- --verbose

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("dev", "prod")]
    [string]$Flavor,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ExtraArgs
)

$ErrorActionPreference = "Stop"

# --- 1. Incrementar build number en pubspec.yaml ---
$pubspecPath = Join-Path $PSScriptRoot "..\pubspec.yaml"
$content = Get-Content $pubspecPath -Raw

if ($content -notmatch '(?m)^version:\s*(\d+\.\d+\.\d+)(?:\+(\d+))?\s*$') {
    throw "No se encontró una línea 'version:' válida en pubspec.yaml"
}

$semver = $Matches[1]
$currentBuild = if ($Matches[2]) { [int]$Matches[2] } else { 0 }
$newBuild = $currentBuild + 1

$newContent = $content -replace '(?m)^version:\s*\d+\.\d+\.\d+(?:\+\d+)?\s*$', "version: $semver+$newBuild"
Set-Content -Path $pubspecPath -Value $newContent -NoNewline

Write-Host "Build number actualizado: $semver+$currentBuild -> $semver+$newBuild"

# --- 2. Generar el APK para el entorno indicado ---
Write-Host "Generando APK para el entorno '$Flavor'..."
fvm flutter build apk --flavor $Flavor --release @ExtraArgs

# --- 3. Abrir carpeta donde se encuentra el APK ---
$apkPath = Join-Path $PSScriptRoot "..\build\app\outputs\flutter-apk\"
Invoke-Item $apkPath