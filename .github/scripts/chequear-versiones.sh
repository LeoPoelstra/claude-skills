#!/usr/bin/env bash
# Compara las versiones anotadas en diseno-web/versiones.json con las últimas
# publicadas. Si hay alguna nueva, escribe el texto del issue en cuerpo.md.
# Deja en $GITHUB_OUTPUT: hay=true|false
set -euo pipefail

VERSIONES="diseno-web/versiones.json"
SALIDA="${GITHUB_OUTPUT:-/dev/stdout}"

ultima() {
  case "$1" in
    impeccable)    npm view impeccable version ;;
    skillui)       npm view skillui version ;;
    ui-ux-pro-max) curl -fsSL https://raw.githubusercontent.com/nextlevelbuilder/ui-ux-pro-max-skill/main/.claude-plugin/plugin.json | jq -r .version ;;
  esac
}

nombre() {
  case "$1" in
    impeccable)    echo "Impeccable" ;;
    skillui)       echo "SkillUI" ;;
    ui-ux-pro-max) echo "UI/UX Pro Max" ;;
  esac
}

cambios() {
  case "$1" in
    impeccable)    echo "https://github.com/pbakaus/impeccable/releases" ;;
    skillui)       echo "https://github.com/amaancoderx/npxskillui/commits/main" ;;
    ui-ux-pro-max) echo "https://github.com/nextlevelbuilder/ui-ux-pro-max-skill/releases" ;;
  esac
}

filas=""
nuevas="{}"
for h in impeccable ui-ux-pro-max skillui; do
  tengo="$(jq -r --arg h "$h" '.[$h]' "$VERSIONES")"
  nueva="$(ultima "$h")"
  if [ -z "$nueva" ] || [ "$nueva" = "null" ]; then
    echo "::warning::No pude consultar la última versión de $h"
    continue
  fi
  echo "$h: tengo $tengo, última $nueva"
  if [ "$nueva" != "$tengo" ]; then
    filas+="| $(nombre "$h") | $tengo | **$nueva** | [ver cambios]($(cambios "$h")) |"$'\n'
    nuevas="$(jq -c --arg h "$h" --arg v "$nueva" '.[$h] = $v' <<<"$nuevas")"
  fi
done

if [ -z "$filas" ]; then
  echo "hay=false" >> "$SALIDA"
  exit 0
fi

cat > cuerpo.md <<EOF
Salieron versiones nuevas de tus herramientas de diseño web:

| Herramienta | Tenés | Nueva | Qué cambió |
|---|---|---|---|
${filas}
### Cómo actualizar

1. **(Opcional, recomendado)** En una sesión de Claude en tu Mac pedí:
   *"Revisá qué cambió en estas versiones nuevas y si es seguro actualizar"*, y pegale el link de este issue.
2. Actualizá. Elegí una de dos:
   - Pedile a Claude: *"actualizá mis herramientas de diseño web"*
   - O en la Terminal: \`bash ~/claude-skills/diseno-web/actualizar.sh\`
3. **Cerrá este issue.** Al cerrarlo, el repo anota estas versiones como las que tenés
   y no te vuelve a avisar por ellas.

Playwright no aparece porque se actualiza solo.

<!-- versiones: ${nuevas} -->
EOF

echo "hay=true" >> "$SALIDA"
