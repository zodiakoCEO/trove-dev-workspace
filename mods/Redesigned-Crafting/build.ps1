# Compila "Redesigned - Crafting" con la busqueda en el Market integrada.
#   1. Recompila las clases de scripts\ sobre original\crafting.swf (ffdec) -> ui\crafting.swf
#   2. Copia el SWF a Live\ui\override\ para empaquetarlo con /buildmod desde el juego
#      (el devtool por linea de comandos falla con "Failed reading", ver CLAUDE.md).
#   -Cleanup: borra Live\ui\override\crafting.swf (y la carpeta si queda vacia) tras empaquetar.
param(
    [string]$Live = "C:\Program Files (x86)\Glyph\Games\Trove\Live",
    [string]$FFDec = "C:\Program Files (x86)\FFDec\ffdec-cli.exe",
    [switch]$Cleanup
)
$ErrorActionPreference = "Stop"
$here = $PSScriptRoot
$override = Join-Path $Live "ui\override"

if ($Cleanup) {
    Remove-Item (Join-Path $override "crafting.swf") -ErrorAction SilentlyContinue
    if ((Test-Path $override) -and -not (Get-ChildItem $override)) { Remove-Item $override }
    Write-Host "Override eliminado."
    return
}

New-Item -ItemType Directory -Force "$here\ui" | Out-Null
$stage = Join-Path $env:TEMP "redesigned-crafting-import"
Remove-Item -Recurse -Force $stage -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force "$stage\scripts" | Out-Null
Copy-Item "$here\scripts\*.as" "$stage\scripts\"

$out = & $FFDec -importScript "$here\original\crafting.swf" "$here\ui\crafting.swf" $stage 2>&1
$out | Write-Host
if (($out | Out-String) -match "(?i)error|exception") { throw "ffdec no pudo compilar los scripts" }

New-Item -ItemType Directory -Force $override | Out-Null
Copy-Item "$here\ui\crafting.swf" (Join-Path $override "crafting.swf") -Force
$others = Get-ChildItem $Live -Recurse -Directory -Filter override | Get-ChildItem -Recurse -File | Where-Object { $_.FullName -ne (Join-Path $override "crafting.swf") }
if ($others) { Write-Warning "Hay otros archivos override que /buildmod tambien empaquetaria:"; $others.FullName | Write-Warning }

Write-Host ""
Write-Host "SWF listo en $override\crafting.swf. En el chat de Trove ejecuta:"
Write-Host '/buildmod title="Redesigned - Crafting" author="Geoflay" notes="Design by Boldd. Market search: LiuLianF. Merge: zodiakoCEO" tags="GUI"'
Write-Host "Reinicia Trove y luego: .\build.ps1 -Cleanup"
