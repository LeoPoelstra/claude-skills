#!/usr/bin/env bash
# Guarda una copia de una herramienta en el Release "respaldo-<nombre>" de
# este repo, pisando la anterior. Solo trabaja si salió una versión nueva
# (o si FORZAR=true).
#
# Archivos que deja en el Release:
#   <nombre>-historial.bundle  repo completo con toda su historia (git clone <archivo>)
#   <nombre>-codigo.zip        el código actual, para mirarlo sin git
#   <nombre>-npm.tgz           el paquete exacto que se instala (si sale de npm)
#
# Uso: bash .github/scripts/respaldar.sh <playwright-mcp|impeccable|ui-ux-pro-max|skillui>
set -euo pipefail

n="$1"
case "$n" in
  playwright-mcp) titulo="Playwright MCP"; repo="microsoft/playwright-mcp";           npm="@playwright/mcp" ;;
  impeccable)     titulo="Impeccable";     repo="pbakaus/impeccable";                 npm="impeccable" ;;
  ui-ux-pro-max)  titulo="UI/UX Pro Max";  repo="nextlevelbuilder/ui-ux-pro-max-skill"; npm="" ;;
  skillui)        titulo="SkillUI";        repo="amaancoderx/npxskillui";             npm="skillui" ;;
  *) echo "Herramienta desconocida: $n" >&2; exit 1 ;;
esac
tag="respaldo-$n"

if [ -n "$npm" ]; then
  version="$(npm view "$npm" version)"
else
  version="$(curl -fsSL "https://raw.githubusercontent.com/$repo/HEAD/.claude-plugin/plugin.json" | jq -r .version)"
fi

anterior="$(gh release view "$tag" --json body --jq .body 2>/dev/null \
  | sed -n 's/^<!-- version: \(.*\) -->[[:space:]]*$/\1/p' | head -1 || true)"
echo "$titulo: versión publicada $version, respaldada ${anterior:-ninguna}"
if [ "$version" = "$anterior" ] && [ "${FORZAR:-false}" != "true" ]; then
  echo "Ya está respaldada. Nada que hacer."
  exit 0
fi

trabajo="$(mktemp -d)"
git clone --quiet --bare "https://github.com/$repo.git" "$trabajo/src.git"
commit="$(git -C "$trabajo/src.git" rev-parse HEAD)"
git -C "$trabajo/src.git" bundle create "$trabajo/$n-historial.bundle" --all
git -C "$trabajo/src.git" archive --format=zip -o "$trabajo/$n-codigo.zip" HEAD
archivos=("$trabajo/$n-historial.bundle" "$trabajo/$n-codigo.zip")
if [ -n "$npm" ]; then
  (cd "$trabajo" && npm pack --silent "$npm@$version" >/dev/null && mv ./*.tgz "$n-npm.tgz")
  archivos+=("$trabajo/$n-npm.tgz")
fi

cat > "$trabajo/notas.md" <<EOF
Copia de respaldo de **$titulo**, desde el repo original [$repo](https://github.com/$repo).
Se pisa sola cada vez que sale una versión nueva.

- **Versión:** $version
- **Commit:** [\`${commit:0:7}\`](https://github.com/$repo/commit/$commit)
- **Fecha del respaldo:** $(date -u +%F)

### Qué hay acá

| Archivo | Para qué |
|---|---|
| \`$n-historial.bundle\` | El repo completo, con toda su historia. |
| \`$n-codigo.zip\` | El código de esta versión, para mirarlo sin git. |
$( [ -n "$npm" ] && echo "| \`$n-npm.tgz\` | El paquete exacto que se instala desde npm. |" )

### Cómo recuperarlo si el original desaparece

\`\`\`bash
git clone $n-historial.bundle $n
\`\`\`
$( [ -n "$npm" ] && printf '\nPara instalar el paquete guardado en vez del de npm: `npm install -g ./%s-npm.tgz`\n' "$n" )
<!-- version: $version -->
EOF

if gh release view "$tag" >/dev/null 2>&1; then
  gh release upload "$tag" "${archivos[@]}" --clobber
  gh release edit "$tag" --title "Respaldo: $titulo $version" --notes-file "$trabajo/notas.md"
else
  gh release create "$tag" "${archivos[@]}" --title "Respaldo: $titulo $version" \
    --notes-file "$trabajo/notas.md" --latest=false
fi
rm -rf "$trabajo"
echo "Respaldo de $titulo $version listo."
