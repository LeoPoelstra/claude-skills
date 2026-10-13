#!/usr/bin/env bash
# Pone el kit de diseño web DENTRO de un proyecto, para que ande igual en
# cualquier Mac y en las sesiones de Claude en la nube (que no ven lo que
# instalaste en tu Mac). Se puede correr las veces que quieras: si ya estaba,
# lo deja al día.
#
# Uso:  bash ~/claude-skills/diseno-web/proyecto.sh [carpeta del proyecto]
#       (sin carpeta, usa la carpeta actual)
#
# Qué agrega al proyecto (todo para commitear):
#   CLAUDE.md                    el bloque "Diseño web" (el resto no se toca)
#   .mcp.json                    Playwright MCP
#   .claude/playwright-mcp.sh    arranca Playwright en la Mac o en la nube
#   .claude/settings.json        UI/UX Pro Max + estadísticas de Impeccable apagadas
#   .claude/skills/impeccable/   Impeccable, versión auditada, sin hooks
#   .claude/agents/impeccable-*  los ayudantes de Impeccable
#   .gitignore                   ignora el binario de Impeccable y las capturas de Playwright

set -u
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

PROYECTO="$(cd "${1:-.}" 2>/dev/null && pwd)" || { falta "No existe la carpeta ${1:-.}"; exit 1; }
if ! command -v node >/dev/null 2>&1; then
  falta "Falta Node.js. Instalalo desde https://nodejs.org y volvé a correr esto."
  exit 1
fi
if [ "$PROYECTO" = "$HOME" ] || [ "$PROYECTO" = "$DIR" ] || [ "$PROYECTO" = "$(dirname "$DIR")" ]; then
  falta "Corré esto sobre la carpeta de un proyecto, no sobre $PROYECTO."
  exit 1
fi
# Versión de Impeccable que revisaste (la de versiones.json), no la última.
IMPECCABLE_VERSION="$(node -p "require('$DIR/versiones.json').impeccable")"

echo "Proyecto: $PROYECTO"

paso "1/5 Impeccable $IMPECCABLE_VERSION en .claude/skills (sin hooks)"
if (cd "$PROYECTO" && npx -y "impeccable@$IMPECCABLE_VERSION" install \
      --providers=claude --scope=project --no-hooks --force -y >/dev/null); then
  # El binario depende de la compu (Mac, Linux…). No se guarda en el repo:
  # el lanzador de Impeccable lo baja y verifica solo la primera vez.
  rm -rf "$PROYECTO/.claude/skills/impeccable/scripts/bin"
  ok "Instalado"
else
  falta "No pude instalar Impeccable (¿sin internet?)"; exit 1
fi

paso "2/5 Playwright MCP en .mcp.json"
mkdir -p "$PROYECTO/.claude"
cp "$DIR/proyecto/.claude/playwright-mcp.sh" "$PROYECTO/.claude/playwright-mcp.sh"
chmod +x "$PROYECTO/.claude/playwright-mcp.sh"
node -e '
  const fs = require("fs"), f = process.argv[1];
  let c = {};
  try { c = JSON.parse(fs.readFileSync(f, "utf8")); } catch (e) {}
  c.mcpServers = c.mcpServers || {};
  c.mcpServers.playwright = { command: "sh", args: [".claude/playwright-mcp.sh"] };
  fs.writeFileSync(f, JSON.stringify(c, null, 2) + "\n");
' "$PROYECTO/.mcp.json" && ok "Listo"

paso "3/5 UI/UX Pro Max y ajustes en .claude/settings.json"
node -e '
  const fs = require("fs"), f = process.argv[1];
  let c = {};
  try { c = JSON.parse(fs.readFileSync(f, "utf8")); } catch (e) {}
  c.extraKnownMarketplaces = c.extraKnownMarketplaces || {};
  c.extraKnownMarketplaces["ui-ux-pro-max-skill"] = {
    source: { source: "github", repo: "nextlevelbuilder/ui-ux-pro-max-skill" }
  };
  c.enabledPlugins = c.enabledPlugins || {};
  c.enabledPlugins["ui-ux-pro-max@ui-ux-pro-max-skill"] = true;
  c.env = c.env || {};
  c.env.IMPECCABLE_NO_TELEMETRY = "1";
  fs.writeFileSync(f, JSON.stringify(c, null, 2) + "\n");
' "$PROYECTO/.claude/settings.json" && ok "Listo"

paso "4/5 .gitignore"
for linea in ".claude/skills/impeccable/scripts/bin/" ".playwright-mcp/"; do
  grep -qxF "$linea" "$PROYECTO/.gitignore" 2>/dev/null || {
    [ -s "$PROYECTO/.gitignore" ] && [ -n "$(tail -c1 "$PROYECTO/.gitignore")" ] && echo >> "$PROYECTO/.gitignore"
    echo "$linea" >> "$PROYECTO/.gitignore"
  }
done
ok "Listo"

paso "5/5 Instrucción \"Diseño web\" en CLAUDE.md del proyecto"
actualizar_claude_md "$PROYECTO/CLAUDE.md" && ok "Lista"

echo
echo "Kit de diseño web al día en $PROYECTO 🎉"
echo "Revisá los cambios con  git -C \"$PROYECTO\" status  y hacé commit."
