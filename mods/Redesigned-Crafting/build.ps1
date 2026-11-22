# Compila "Redesigned - Crafting" con la búsqueda en el Market integrada.
#   1. Recompila las clases de scripts\ sobre original\crafting.swf (ffdec) -> ui\crafting.swf
#   2. Empaqueta el .tmod con el devtool de la instalación indicada (Glyph por defecto)
#   3. Guarda copia en build\ del repo (el devtool deja el .tmod en Live\mods\)
param(
    [string]$Live = "C:\Program Files (x86)\Glyph\Games\Trove\Live",
    [string]$FFDec = "C:\Program Files (x86)\FFDec\ffdec-cli.exe"
)
$ErrorActionPreference = "Stop"
$here = $PSScriptRoot
$title = "Redesigned - Crafting"
$repo = (Resolve-Path "$here\..\..").Path

New-Item -ItemType Directory -Force "$here\ui" | Out-Null
$stage = Join-Path $env:TEMP "redesigned-crafting-import"
Remove-Item -Recurse -Force $stage -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force "$stage\scripts" | Out-Null
Copy-Item "$here\scripts\*.as" "$stage\scripts\"

$out = & $FFDec -importScript "$here\original\crafting.swf" "$here\ui\crafting.swf" $stage 2>&1
$out | Write-Host
if (($out | Out-String) -match "(?i)error|exception") { throw "ffdec no pudo compilar los scripts" }

$tmod = Join-Path $Live "mods\$title.tmod"
$before = if (Test-Path $tmod) { (Get-Item $tmod).LastWriteTime } else { [datetime]::MinValue }
Push-Location $here
try {
    & cmd /c "`"$Live\devtool.bat`" buildmod -author `"Geoflay (search: LiuLianF, merge: zodiakoCEO)`" -title `"$title`" -notes `"Design by Boldd. Click an ingredient to search it in the Marketplace.`" -tags `"GUI`" - ui/crafting.swf"
} finally { Pop-Location }

# El devtool trabaja en segundo plano y no imprime nada: esperar al .tmod nuevo.
function Test-Built { (Test-Path $tmod) -and ((Get-Item $tmod).LastWriteTime -gt $before) }
for ($i = 0; $i -lt 30; $i++) {
    if (Test-Built) { break }
    Start-Sleep 1
}
if (-not (Test-Built)) { throw "El devtool no genero $tmod" }

New-Item -ItemType Directory -Force "$repo\build" | Out-Null
Copy-Item $tmod "$repo\build\" -Force
Write-Host "OK: $tmod ($((Get-Item $tmod).Length) bytes)"
