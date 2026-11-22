---
description: Compila el mod a .tmod (queda instalado en Trove) y hace commit + push
argument-hint: <NombreMod>
---

Publica el mod: $ARGUMENTS

1. Lista los archivos de `mods/$ARGUMENTS/` con rutas relativas y `/` (p. ej. `ui/hud.swf`), excluyendo el preview si no forma parte del mod.
2. Compila desde la carpeta del mod:
   ```powershell
   Set-Location "mods\$ARGUMENTS"
   & "C:\Program Files (x86)\Steam\steamapps\common\Trove\Games\Trove\Live\devtool.bat" buildmod -author "zodiakoCEO" -title "$ARGUMENTS" -notes "<descripción>" -preview "<ruta/preview.png>" -tags "<tags>" - <archivo1> <archivo2> ...
   ```
   Omite `-preview` si no hay imagen.
3. Verifica que `C:\Program Files (x86)\Steam\steamapps\common\Trove\Games\Trove\Live\mods\$ARGUMENTS.tmod` existe y que su fecha es reciente. El devtool no imprime nada y puede devolver código 1 aunque haya funcionado. Si el archivo no se generó, arregla el problema y vuelve a compilar.
4. Copia el `.tmod` a `build/` como respaldo local.
5. Haz `git add` de los cambios fuente (nunca `build/` ni `.tmod`), commit en español con mensaje descriptivo y `git push`.
6. Informa la ruta del `.tmod`, el hash del commit y cualquier advertencia (recordar reiniciar Trove para cargar el mod).
