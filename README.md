# claude-skills

Mis herramientas y configuraciones para Claude Code, instalables en cualquier
Mac con un solo comando. Todo queda **para todos los proyectos**: la terminal y
la parte **Code** de Claude escritorio.

| Carpeta | Qué hace |
|---|---|
| [`diseno-web/`](diseno-web/) | 4 herramientas para que Claude diseñe webs mucho mejor (Playwright, Impeccable, UI/UX Pro Max, SkillUI) + la instrucción que las usa sola cada vez que pido una web. |

## Instalar en una Mac nueva

En la Terminal:

```bash
cd ~
git clone https://github.com/LeoPoelstra/claude-skills
bash ~/claude-skills/diseno-web/instalar.sh
```

Después cerrá y volvé a abrir Claude escritorio.

## Comandos del día a día

| Para… | Corré |
|---|---|
| Ver si está todo instalado | `bash ~/claude-skills/diseno-web/verificar.sh` |
| Actualizar (una vez por mes alcanza) | `bash ~/claude-skills/diseno-web/actualizar.sh` |
| Reinstalar lo que falte | `bash ~/claude-skills/diseno-web/instalar.sh` |

O directamente pedíselo a Claude en una sesión en tu Mac:
*"actualizá mis herramientas de diseño web"*.

Cuando salen versiones nuevas, una GitHub Action abre un issue en este repo y
te llega el aviso por mail. Detalles en [`diseno-web/README.md`](diseno-web/README.md#aviso-automático-por-mail).

## Respaldos de las herramientas

Por si algún día un repo original desaparece o cambia, la Action
[`respaldos`](.github/workflows/respaldos.yml) guarda una copia de cada
herramienta en los [**Releases**](https://github.com/LeoPoelstra/claude-skills/releases)
de este repo, uno por herramienta ("Respaldo: …"). Revisa todos los días y,
cuando sale una versión nueva, vuelve a copiar y **pisa la copia anterior**.

Cada respaldo trae:

| Archivo | Para qué |
|---|---|
| `…-historial.bundle` | El repo completo con toda su historia. Se recupera con `git clone archivo.bundle carpeta`. |
| `…-codigo.zip` | El código de esa versión, para mirarlo sin git. |
| `…-npm.tgz` | El paquete exacto que se instala desde npm (Playwright, Impeccable, SkillUI). |

Van en Releases y no adentro del repo porque Impeccable con su historia pesa
unos 640 MB: GitHub no acepta archivos de más de 100 MB en un repo, y pisarlos
haría crecer el repo sin parar. Los Releases tampoco se descargan al clonar,
así que tu Mac no se llena.

Para forzar una copia nueva: pestaña *Actions* → *Respaldos de herramientas* →
*Run workflow* → tildá "Volver a copiar todo".

Las cuatro herramientas tienen licencias (MIT y Apache 2.0) que permiten
guardar y compartir copias. Cada respaldo incluye su licencia original.
