# Trove Dev Workspace

Workspace para crear, arreglar y compilar mods `.tmod` de Trove.

## Rutas del sistema (detectadas el 2026-11-21)

### Trove
| Qué | Ruta |
|---|---|
| Trove (Steam, principal) | `C:\Program Files (x86)\Steam\steamapps\common\Trove\Games\Trove\Live\Trove.exe` |
| Trove x64 (Steam) | `C:\Program Files (x86)\Steam\steamapps\common\Trove\Games\Trove\Live\Trove_x64.exe` |
| Devtool oficial | `C:\Program Files (x86)\Steam\steamapps\common\Trove\Games\Trove\Live\devtool.bat` (= `Trove_x64.exe -tool %*`) |
| Carpeta mods del juego (Steam) | `C:\Program Files (x86)\Steam\steamapps\common\Trove\Games\Trove\Live\mods` |
| Trove (Glyph, secundaria) | `C:\Program Files (x86)\Glyph\Games\Trove\Live\Trove_x64.exe` |
| Datos de usuario / configs de mods | `C:\Users\Sebz\AppData\Roaming\Trove` (`ModCfgs`, `mod_locks.json`, `Trove.log`) |

Carpetas de assets en `Live\`: `blueprints`, `models`, `particles`, `prefabs`, `textures`, `ui`, `audio`, `shadersunified`, `languages`.

### Herramientas
| Herramienta | Ruta | Estado |
|---|---|---|
| HxD 2.5 | `C:\Program Files\HxD\HxD.exe` | Instalado |
| PopcornFX 1.13 Editor | `C:\Program Files\Persistant Studios\PopcornFX-1.13\Binaries_Release\PK-Editor.exe` | Instalado |
| PopcornFX AssetBaker | `C:\Program Files\Persistant Studios\PopcornFX-1.13\Binaries_Release\PK-AssetBaker.exe` | Instalado |
| Better Trove Tools | `C:\Program Files\Better Trove Tools\BetterTroveTools.exe` | Instalado |
| TroveTools .NET | `C:\Users\Sebz\AppData\Local\Apps\2.0\4VKJGAZC.QWT\9HDPM3K8.T17\trov..tion_0570929531b11331_0001.0002_f6e5301d8316704d\TroveTools.NET.exe` | Instalado (ClickOnce; la ruta puede cambiar al actualizar) |
| 7-Zip | `C:\Program Files\7-Zip\7z.exe` | Instalado |
| Git | `C:\Program Files\Git\` | Instalado |
| GitHub CLI | `C:\Program Files\GitHub CLI\gh.exe` | Instalado y autenticado |
| VS Code | `C:\Users\Sebz\AppData\Local\Programs\Microsoft VS Code\` | Instalado |
| Python | — | **No instalado** (solo el alias de Microsoft Store en `WindowsApps`). Instalar desde python.org o `winget install Python.Python.3.12` |
| JPEXS / ffdec | — | **No instalado** (necesita Java, que tampoco está instalado) |
| Java | — | **No instalado** |

Instaladores sin ejecutar en `C:\Users\Sebz\Downloads\`: `PopcornFX-Editor_v2.25.3.28568.exe`.

## Estructura del repo
- `mods/<NombreMod>/` — fuente de cada mod, replicando la estructura de `Live\` (p. ej. `mods/MiMod/blueprints/...`, `mods/MiMod/particles/...`, `mods/MiMod/ui/...`).
- `tools/` — scripts propios (build, extracción, utilidades).
- `build/` — salida de `.tmod` compilados (ignorado por git).
- `.claude/commands/` — comandos `/fix`, `/refactor`, `/ship`.

## Compilar un .tmod
Usar el devtool oficial de Trove:

```bat
"C:\Program Files (x86)\Steam\steamapps\common\Trove\Games\Trove\Live\devtool.bat" buildmod -p "<ruta absoluta a mods\NombreMod>" -o "<ruta absoluta a build\>"
```

- Si la sintaxis falla, ejecutar `devtool.bat help` y actualizar este archivo con la sintaxis correcta.
- Extraer assets originales para referencia: `devtool.bat extractarchive "<carpeta de Live>" "<destino>"` (destino fuera del repo o en `extracted/`, que está ignorado).
- Probar: copiar el `.tmod` a `...\Live\mods\` y arrancar Trove; revisar errores en `C:\Users\Sebz\AppData\Roaming\Trove\Trove.log`.

## Reglas de trabajo
- Autonomía total: aplicar fixes, refactors, renombrados, reestructuraciones y compilaciones de mods directamente, sin pedir confirmación.
- Se puede leer cualquier archivo de la instalación de Trove y copiar `.tmod` compilados a la carpeta `mods` del juego.
- No modificar archivos originales del juego fuera de `Live\mods\` (blueprints, `.exe`, `.dll`, `XIGNCODE`); si hace falta, hacer copia de seguridad primero. Trove sobreescribe esos archivos al actualizar.
- Mods cosméticos/de UI, en línea con la política de mods de Trove.
- Tras cada cambio en un mod: compilarlo y revisar `Trove.log` si se prueba en el juego.
- Commits en español, pequeños y descriptivos. Nunca commitear `build/`, `extracted/` ni `.tmod`.
