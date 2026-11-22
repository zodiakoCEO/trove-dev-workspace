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
| Python 3.12.10 | `C:\Users\Sebz\AppData\Local\Programs\Python\Python312\python.exe` | Instalado (es el primero en el PATH; `py -3.12` apunta al mismo. El alias de `WindowsApps\python.exe` queda detrás) |
| JPEXS / ffdec 26.5.0 (GUI) | `C:\Program Files (x86)\FFDec\ffdec.exe` | Instalado (también `ffdec.bat` y `ffdec.jar`) |
| JPEXS / ffdec (CLI) | `C:\Program Files (x86)\FFDec\ffdec-cli.exe` | Instalado (`ffdec-cli.jar` al lado). No está en el PATH: usar la ruta completa |
| Java 21 (Temurin) | `C:\Program Files\Eclipse Adoptium\jdk-21.0.13.10002-hotspot\bin\java.exe` | Instalado. `JAVA_HOME` (usuario) apunta aquí |
| Java 8 (Oracle JRE 1.8.0_513) | `C:\Program Files\Java\jre1.8.0_513\bin\java.exe` | Instalado. Su shim `C:\Program Files (x86)\Common Files\Oracle\Java\java8path\java.exe` va **primero en el PATH**, así que `java` a secas ejecuta Java 8. Para Java 21, usar la ruta completa |

Instaladores sin ejecutar en `C:\Users\Sebz\Downloads\`: `PopcornFX-Editor_v2.25.3.28568.exe`.

## Estructura del repo
- `mods/<NombreMod>/` — fuente de cada mod, replicando la estructura de `Live\` (p. ej. `mods/MiMod/blueprints/...`, `mods/MiMod/particles/...`, `mods/MiMod/ui/...`).
- `tools/` — scripts propios (build, extracción, utilidades).
- `build/` — copias de los `.tmod` compilados (ignorado por git). El devtool los genera en `Live\mods\`.
- `.claude/commands/` — comandos `/fix`, `/refactor`, `/ship`.

## Compilar un .tmod
Sintaxis oficial (verificada en el texto `$BuildModTool_Usage` de `languages/en`, 2026-11-21):

```
Trove.exe -tool buildmod -author "Author Name" -title "Mod Title" -notes "Mod Notes" -preview "path/to/preview.png" -tags "a,b,c,d" - <file1> <file2>
Trove.exe -tool buildmod -meta MetaFile.yaml
```

Cómo usarla en este repo (ejecutar **desde la carpeta del mod** para que las rutas de los archivos coincidan con las del juego):

```powershell
Set-Location "mods\NombreMod"
& "C:\Program Files (x86)\Steam\steamapps\common\Trove\Games\Trove\Live\devtool.bat" buildmod -author "zodiakoCEO" -title "NombreMod" -notes "Descripción" -preview "ui/preview.png" -tags "ui" - ui/archivo1.swf textures/archivo2.png
```

- **No hay parámetro de salida:** el resultado siempre es `C:\Program Files (x86)\Steam\steamapps\common\Trove\Games\Trove\Live\mods\<Title>.tmod`, y si ya existe se reemplaza. Mensaje de éxito: `Successfully built mods/<Title>.tmod`.
- Son obligatorios `-author`, `-title` y al menos un archivo. Los archivos van después de un `-` suelto.
- Las rutas, incluida la del preview, van con `/` y relativas a la raíz de assets (`ui/...`, `particles/...`, `blueprints/...`). El preview puede ser PNG, JPG o BLUEPRINT.
- El devtool no imprime nada en consola (ni siquiera con `help`) y puede devolver código 1 aunque haya funcionado. Para confirmar el resultado, comprobar que el `.tmod` existe y que su fecha de modificación es reciente.
- Variante `-meta MetaFile.yaml`: aún no se ha probado el formato del YAML. Usar la variante con parámetros hasta comprobarlo.
- Desde el juego también existe `/buildmod title="..." author="..." notes="..." preview="..." tags="..."`, que empaqueta lo que haya en las carpetas `override`.
- Extraer assets originales: `devtool.bat extractarchive "<carpeta con index.tfi>" "<destino>"` (probado con `languages\en`, funciona aunque devuelva código 1). El destino debe estar fuera del repo o en `extracted/`, que git ignora.
- Probar: el `.tmod` ya queda en `Live\mods\`. Reiniciar Trove y revisar los errores en `C:\Users\Sebz\AppData\Roaming\Trove\Trove.log`.

## Reglas de trabajo
- Autonomía total: aplicar fixes, refactors, renombrados, reestructuraciones y compilaciones de mods directamente, sin pedir confirmación.
- Se puede leer cualquier archivo de la instalación de Trove y copiar `.tmod` compilados a la carpeta `mods` del juego.
- No modificar archivos originales del juego fuera de `Live\mods\` (blueprints, `.exe`, `.dll`, `XIGNCODE`); si hace falta, hacer copia de seguridad primero. Trove sobreescribe esos archivos al actualizar.
- Mods cosméticos/de UI, en línea con la política de mods de Trove.
- Tras cada cambio en un mod: compilarlo y revisar `Trove.log` si se prueba en el juego.
- Commits en español, pequeños y descriptivos. Nunca commitear `build/`, `extracted/` ni `.tmod`.
