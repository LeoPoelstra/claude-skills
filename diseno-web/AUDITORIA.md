# Auditoría de las 4 herramientas

Revisión hecha el 13/10/2026 antes de instalarlas: código fuente de cada repo,
paquete publicado en npm, scripts de instalación, hooks y conexiones de red.
Los instaladores se probaron en una carpeta descartable.

**Resultado: las 4 son confiables.** Ninguna roba datos ni hace nada
malicioso. Las que más valen la pena son Playwright e Impeccable.

## Playwright MCP — `@playwright/mcp`

- **Quién:** Microsoft (mantenedores del equipo de Playwright).
- **Uso:** ~30 millones de descargas por mes en npm.
- **Riesgos:** ninguno encontrado. Sin scripts de instalación.
- **Veredicto:** ✅ Confiable. La más útil: cierra el ciclo haciendo que Claude
  pruebe lo que construye.

## Impeccable — `impeccable` (versión revisada: 4.5.2, motor 0.1.14)

- **Quién:** Paul Bakaus (creador de jQuery UI). Licencia Apache 2.0.
- **Uso:** ~750 mil descargas por mes, mantenido activamente.
- **A tener en cuenta:**
  - Puede instalar **hooks** (al abrir sesión, después de cada edición y al
    terminar). Acá se instala **sin hooks** (`--no-hooks`).
  - Descarga un binario propio desde los releases de GitHub y **verifica su
    sha256** antes de ejecutarlo; si no puede verificarlo, se niega.
  - **Estadísticas anónimas** activadas de fábrica (qué estilo visual se
    eligió; nunca nombres, archivos ni código). `instalar.sh` las apaga con
    `"telemetry": false` en `~/.impeccable/config.json`. Ojo: el comando
    `npx impeccable telemetry off` que menciona su README no existe en esta
    versión.
- **Veredicto:** ✅ Confiable. Muy útil.

## UI/UX Pro Max — plugin `ui-ux-pro-max@ui-ux-pro-max-skill` (versión 2.15.0)

- **Quién:** nextlevelbuilder. Licencia MIT, muy usado.
- **Qué instala:** 7 skills (ui-ux-pro-max, design-system, ui-styling, brand,
  design, slides, banner-design), ~10 MB de datos locales y scripts de Python.
- **Riesgos:** sin hooks; los scripts principales trabajan con datos locales
  (CSV) y no se conectan a internet.
- **Veredicto:** ✅ Confiable. Útil para arrancar con paleta y tipografías,
  aunque se superpone en parte con Impeccable.

## SkillUI — `skillui` (versión revisada: 1.3.4)

- **Quién:** un solo desarrollador (amaancoderx), 7 commits, sin cambios
  desde mayo de 2026. ~21 mil descargas por mes.
- **Código:** limpio. Análisis estático de CSS/HTML; el paquete publicado en npm
  coincide con el repo y no tiene scripts de instalación.
- **A tener en cuenta:** para las capturas manda la URL analizada a un servicio
  externo (`api.microlink.io`). Con webs públicas está bien; **no usarlo con
  URLs privadas o internas**.
- **Veredicto:** ⚠️ Aceptable. Útil de vez en cuando para tomar una web de
  referencia. Nunca copiar el diseño, solo usarlo como inspiración.
