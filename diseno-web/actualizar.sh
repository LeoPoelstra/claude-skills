#!/usr/bin/env bash
# Trae la última versión de las herramientas de diseño web y refresca la
# instrucción global. Playwright no hace falta: se actualiza solo (@latest).
#
# Uso:  bash ~/claude-skills/diseno-web/actualizar.sh

set -u
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

requisitos

paso "Trayendo la última versión de este repo"
if git -C "$DIR" pull --ff-only >/dev/null 2>&1; then ok "Repo al día"
else aviso "No pude actualizar el repo (¿sin internet o con cambios locales?). Sigo igual."; fi

paso "Impeccable"
en_carpeta_vacia npx -y impeccable@latest update --global --no-hooks -y && ok "Actualizado"
impeccable_sin_telemetria

paso "UI/UX Pro Max"
claude plugin marketplace update ui-ux-pro-max-skill >/dev/null 2>&1
claude plugin update ui-ux-pro-max@ui-ux-pro-max-skill && ok "Actualizado"

paso "SkillUI"
if command -v skillui >/dev/null 2>&1; then
  npm update -g skillui >/dev/null 2>&1 && ok "Actualizado" || aviso "No se pudo actualizar (permisos)"
else
  ok "Se usa con npx, siempre trae la última"
fi

paso "Instrucción \"Diseño web\""
actualizar_claude_md && ok "Al día"

verificar
