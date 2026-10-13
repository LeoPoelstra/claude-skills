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
