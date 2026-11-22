---
description: Compila el mod a .tmod, lo instala en Trove y hace commit + push
argument-hint: <NombreMod>
---

Publica el mod: $ARGUMENTS

1. Compila `mods/$ARGUMENTS` a `build/` con `devtool.bat buildmod` (ver CLAUDE.md). Si falla, arréglalo y vuelve a compilar.
2. Copia el `.tmod` resultante a `C:\Program Files (x86)\Steam\steamapps\common\Trove\Games\Trove\Live\mods\`.
3. Haz `git add` de los cambios fuente (nunca `build/` ni `.tmod`), commit en español con mensaje descriptivo y `git push`.
4. Informa la ruta del `.tmod`, el hash del commit y cualquier advertencia.
