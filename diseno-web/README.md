# Diseño web con Claude

Cuatro herramientas que le dan a Claude criterio visual y una forma de probar
lo que construye, más una instrucción global para que las use **solo**, cada
vez que le pido una web, webapp, landing o cualquier cosa en HTML.

Basado en la guía
[4 skills para que Claude diseñe webs mucho mejor](https://observant-caravel-03f.notion.site/4-SKILLS-PARA-QUE-CLAUDE-DISE-E-WEBS-MUCHO-MEJOR-3f28d331c92280b7828dcf6efe166d37).
Antes de instalarlas revisé el código de cada una: ver [AUDITORIA.md](AUDITORIA.md).

| Herramienta | Para qué sirve | ¿Se actualiza sola? |
|---|---|---|
| [Playwright MCP](https://github.com/microsoft/playwright-mcp) | Claude abre el navegador, hace clic, completa formularios y prueba la web que hizo. | ✅ Sí (`@latest`) |
| [Impeccable](https://github.com/pbakaus/impeccable) | Criterio de diseño: evita webs "con cara de IA" y audita jerarquía, tipografía, espaciados, accesibilidad. | ❌ `actualizar.sh` |
| [UI/UX Pro Max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | Arma el sistema de diseño antes de programar: paleta, tipografías, componentes, reglas UX. | ❌ `actualizar.sh` |
| [SkillUI](https://github.com/amaancoderx/npxskillui) | Saca colores, tipografías y espaciados de una web de referencia. | ❌ `actualizar.sh` |

## Instalar

```bash
cd ~
git clone https://github.com/LeoPoelstra/claude-skills
bash ~/claude-skills/diseno-web/instalar.sh
```

Cerrá y volvé a abrir Claude escritorio. Se puede correr las veces que
quieras: lo que ya está instalado lo saltea.

Qué hace `instalar.sh`:

1. **Playwright MCP** a nivel usuario (`claude mcp add --scope user`).
2. **UI/UX Pro Max** como plugin a nivel usuario.
3. **Impeccable** a nivel usuario, **sin hooks** y con las estadísticas
   anónimas apagadas (`~/.impeccable/config.json`).
4. **SkillUI** global con npm. Si no hay permisos, no pasa nada: Claude lo usa
   con `npx skillui`.
5. Agrega el bloque [CLAUDE-diseno-web.md](CLAUDE-diseno-web.md) a
   `~/.claude/CLAUDE.md` sin tocar el resto del archivo. Si ya había una
   versión vieja del bloque, la reemplaza.

## Cómo se usa

En Claude escritorio abrí una sesión de **Code en tu Mac** (no en la nube ☁️),
elegí una carpeta y pedí lo que quieras, por ejemplo:

> Haceme una landing para un estudio de yoga en Palermo, público de 30 a 50
> años, estilo cálido y tranquilo.

Claude sigue solo el proceso de [CLAUDE-diseno-web.md](CLAUDE-diseno-web.md):
te pregunta lo que falte, te muestra el sistema de diseño, espera tu OK,
construye, audita con Impeccable, prueba con Playwright en escritorio y celular,
corrige y recién ahí te dice que está listo.

Para cambiar el proceso o el estilo por defecto, editá
`CLAUDE-diseno-web.md` en este repo y corré `actualizar.sh`.

**No funciona en la parte "Chat"** de Claude escritorio. Las sesiones en la
nube tampoco ven lo que está instalado en tu Mac: para esas, poné el kit
dentro del proyecto (abajo).

## Poner el kit dentro de un proyecto

Así anda igual en la nube ☁️, en otra Mac o si alguien más abre el repo:

```bash
bash ~/claude-skills/diseno-web/proyecto.sh ~/Proyectos/mi-web
```

O pedíselo a Claude dentro del proyecto: *"poné el kit de diseño web en este
proyecto"*. Agrega al repo (todo para commitear):

| Archivo | Qué es |
|---|---|
| `CLAUDE.md` | El bloque "Diseño web". El resto del archivo no se toca. |
| `.mcp.json` + `.claude/playwright-mcp.sh` | Playwright. En la Mac usa Chrome; en la nube, el Chromium que ya trae, sin ventana. |
| `.claude/settings.json` | Activa UI/UX Pro Max y apaga las estadísticas de Impeccable. Lo que ya tenías se mantiene. |
| `.claude/skills/impeccable/`, `.claude/agents/impeccable-*` | Impeccable en la versión anotada en [`versiones.json`](versiones.json), sin hooks. Su programa (unos 20 MB, distinto en Mac y Linux) no se guarda: lo baja y verifica solo la primera vez. |
| `.gitignore` | Ignora ese programa y las capturas de Playwright (`.playwright-mcp/`). |

La primera vez que abras el proyecto, Claude te pregunta si confiás en
Playwright y en UI/UX Pro Max: decí que sí.

Cuando actualices Impeccable (issue mensual), corré `proyecto.sh` de nuevo en
cada proyecto para dejarlo en la versión nueva.

## Por qué sin hooks

Impeccable puede instalar hooks que revisan el diseño después de cada edición.
Instalados para todos los proyectos, se dispararían también en las tareas
automáticas del mail (TM-FGB corre `claude -p` todos los días y cada 30 min).
La instrucción global ya le dice a Claude que audite con Impeccable cuando hace
una web, así que los hooks no hacen falta.

## Actualizar

```bash
bash ~/claude-skills/diseno-web/actualizar.sh
```

Trae la última versión de este repo, de Impeccable, UI/UX Pro Max y SkillUI,
y refresca el bloque de `CLAUDE.md`. No las dejo en actualización automática a
propósito: la auditoría vale para las versiones que revisé, y así cada
actualización es una decisión tuya.

### Aviso automático por mail

No hace falta acordarse: la Action
[`actualizaciones-diseno-web`](../.github/workflows/actualizaciones-diseno-web.yml)
chequea **el día 1 de cada mes** si salieron versiones nuevas. Si hay, abre un
issue en este repo (GitHub te lo manda por mail) con qué cambió y los pasos:

1. (Opcional) Pedirle a Claude que revise si los cambios son seguros.
2. Actualizar: *"actualizá mis herramientas de diseño web"* o `actualizar.sh`.
3. **Cerrar el issue.** Al cerrarlo, la Action anota esas versiones en
   [`versiones.json`](versiones.json) y no vuelve a avisar por ellas.

La Action **no actualiza tu Mac**: GitHub no tiene acceso a ella. Solo avisa.
Para chequear a mano: pestaña *Actions* → *Actualizaciones de diseño web* →
*Run workflow*. Hace un commit chiquito por mes con la fecha del chequeo, porque
GitHub apaga las Actions programadas de repos públicos que pasan 60 días sin
actividad.

## Verificar

```bash
bash ~/claude-skills/diseno-web/verificar.sh
```

No cambia nada, solo muestra ✅ / ❌ de cada herramienta.

## Desinstalar

```bash
claude mcp remove --scope user playwright
claude plugin uninstall ui-ux-pro-max@ui-ux-pro-max-skill
rm -rf ~/.claude/skills/impeccable ~/.claude/agents/impeccable-*
npm uninstall -g skillui
```

Y borrá a mano el bloque entre `<!-- diseno-web:inicio` y
`<!-- diseno-web:fin -->` en `~/.claude/CLAUDE.md`.
