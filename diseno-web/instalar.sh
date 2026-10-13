#!/usr/bin/env bash
# Instala las 4 herramientas de diseño web para TODOS tus proyectos de
# Claude Code (terminal y la parte "Code" de Claude escritorio).
# Se puede correr las veces que quieras: lo que ya está instalado lo saltea.
#
# Uso:  bash ~/claude-skills/diseno-web/instalar.sh

set -u
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

requisitos

paso "1/5 Playwright MCP (Claude abre el navegador y prueba la web)"
if claude mcp get playwright >/dev/null 2>&1; then
  ok "Ya estaba instalado"
else
  claude mcp add --scope user playwright -- npx @playwright/mcp@latest && ok "Instalado"
fi

paso "2/5 UI/UX Pro Max (sistema de diseño: paletas, tipografías, reglas)"
claude plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill >/dev/null 2>&1 || true
if claude plugin list 2>/dev/null | grep -q "ui-ux-pro-max"; then
  ok "Ya estaba instalado"
else
  claude plugin install --scope user ui-ux-pro-max@ui-ux-pro-max-skill && ok "Instalado"
fi

paso "3/5 Impeccable (criterio de diseño y auditoría)"
if [ -f "$HOME/.claude/skills/impeccable/SKILL.md" ]; then
  ok "Ya estaba instalado (para traer la última versión usá actualizar.sh)"
else
  en_carpeta_vacia npx -y impeccable@latest install --providers=claude --scope=global --no-hooks -y \
    && ok "Instalado"
fi
impeccable_sin_telemetria && ok "Estadísticas anónimas apagadas"

paso "4/5 SkillUI (saca colores y tipografías de una web de referencia)"
if command -v skillui >/dev/null 2>&1; then
  ok "Ya estaba instalado"
elif npm install -g skillui >/dev/null 2>&1; then
  ok "Instalado"
else
  aviso "No se pudo instalar global (permisos). No pasa nada: Claude lo usa con 'npx skillui'."
fi

paso "5/5 Instrucción global \"Diseño web\" en ~/.claude/CLAUDE.md"
actualizar_claude_md && ok "Lista"

verificar
