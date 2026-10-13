# Funciones compartidas por instalar.sh, actualizar.sh y verificar.sh.
# No se ejecuta solo: lo cargan los otros scripts con `source`.

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOQUE="$DIR/CLAUDE-diseno-web.md"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"

ok()    { printf '  ✅ %s\n' "$1"; }
falta() { printf '  ❌ %s\n' "$1"; }
aviso() { printf '  ⚠️  %s\n' "$1"; }
paso()  { printf '\n▶ %s\n' "$1"; }

requisitos() {
  if ! command -v node >/dev/null 2>&1; then
    falta "Falta Node.js. Instalalo desde https://nodejs.org y volvé a correr esto."
    exit 1
  fi
  if [ "$(node -p 'process.versions.node.split(".")[0]')" -lt 18 ]; then
    falta "Tu Node.js es muy viejo ($(node -v)). Necesitás 18 o más: https://nodejs.org"
    exit 1
  fi
  if ! command -v claude >/dev/null 2>&1; then
    falta "No encuentro el comando 'claude'. Instalá Claude Code y volvé a correr esto."
    exit 1
  fi
}

# Corre un comando desde una carpeta vacía y descartable. Impeccable escribe
# sus hooks en la carpeta actual; así no caen en ningún proyecto tuyo.
en_carpeta_vacia() {
  local tmp
  tmp="$(mktemp -d)"
  (cd "$tmp" && "$@")
  local rc=$?
  rm -rf "$tmp"
  return $rc
}

# Apaga las estadísticas anónimas de Impeccable (~/.impeccable/config.json).
impeccable_sin_telemetria() {
  node -e '
    const fs = require("fs"), path = require("path"), os = require("os");
    const dir = path.join(os.homedir(), ".impeccable"), f = path.join(dir, "config.json");
    let c = {};
    try { c = JSON.parse(fs.readFileSync(f, "utf8")); } catch (e) {}
    c.telemetry = false;
    fs.mkdirSync(dir, { recursive: true });
    fs.writeFileSync(f, JSON.stringify(c, null, 2) + "\n");
  '
}

# Deja en ~/.claude/CLAUDE.md (o en el archivo que le pases) la versión
# actual del bloque "Diseño web", reemplazando cualquier versión anterior
# (con o sin marcas) y sin tocar el resto del archivo.
actualizar_claude_md() {
  local destino="${1:-$CLAUDE_MD}"
  mkdir -p "$(dirname "$destino")"
  touch "$destino"
  local tmp
  tmp="$(mktemp)"
  # Copia todo menos el bloque viejo y sin líneas en blanco sobrantes al final.
  awk '
    /<!-- diseno-web:inicio/                { salto = 1 }
    /^## Diseño web \(siempre que te pida/  { salto = 1; viejo = 1 }
    !salto                                  { n++; linea[n] = $0 }
    salto && /<!-- diseno-web:fin -->/      { salto = 0; next }
    salto && viejo && /Mesa de Entrada \/ TM-FGB\)\./ { salto = 0; viejo = 0; next }
    END {
      while (n > 0 && linea[n] ~ /^[[:space:]]*$/) n--
      for (i = 1; i <= n; i++) print linea[i]
    }
  ' "$destino" > "$tmp"
  [ -s "$tmp" ] && printf '\n' >> "$tmp"
  cat "$BLOQUE" >> "$tmp"
  cp "$tmp" "$destino"
  rm -f "$tmp"
}

verificar() {
  local faltan=0
  paso "Verificando herramientas de diseño web"

  if claude mcp get playwright >/dev/null 2>&1; then ok "Playwright MCP"
  else falta "Playwright MCP"; faltan=1; fi

  if claude plugin list 2>/dev/null | grep -q "ui-ux-pro-max"; then ok "UI/UX Pro Max"
  else falta "UI/UX Pro Max"; faltan=1; fi

  if [ -f "$HOME/.claude/skills/impeccable/SKILL.md" ]; then
    ok "Impeccable $(sed -n 's/^version: //p' "$HOME/.claude/skills/impeccable/SKILL.md" | head -1)"
  else falta "Impeccable"; faltan=1; fi

  if command -v skillui >/dev/null 2>&1; then ok "SkillUI"
  else aviso "SkillUI no está instalado global (igual anda con: npx skillui)"; fi

  if grep -q "diseno-web:inicio" "$CLAUDE_MD" 2>/dev/null; then ok "Instrucción \"Diseño web\" en ~/.claude/CLAUDE.md"
  else falta "Instrucción \"Diseño web\" en ~/.claude/CLAUDE.md"; faltan=1; fi

  echo
  if [ "$faltan" = 0 ]; then
    echo "Todo en orden 🎉  Cerrá y volvé a abrir Claude escritorio si recién instalaste o actualizaste."
  else
    echo "Falta algo: corré  bash \"$DIR/instalar.sh\"  y volvé a verificar."
  fi
  return $faltan
}
