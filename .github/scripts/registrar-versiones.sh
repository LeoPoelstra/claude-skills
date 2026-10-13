#!/usr/bin/env bash
# Al cerrar un issue de "actualizaciones", anota en diseno-web/versiones.json
# las versiones que ese issue anunciaba. El texto del issue llega en $CUERPO.
set -euo pipefail

VERSIONES="diseno-web/versiones.json"

json="$(printf '%s\n' "${CUERPO:-}" | sed -n 's/^<!-- versiones: \(.*\) -->[[:space:]]*$/\1/p' | tail -1)"
if [ -z "$json" ] || ! jq -e 'type == "object"' >/dev/null 2>&1 <<<"$json"; then
  echo "::warning::El issue no tiene la lista de versiones; no anoto nada."
  exit 0
fi

# Solo acepta las herramientas conocidas, por si alguien editó el issue.
jq --argjson n "$json" '
  . + ($n | with_entries(select(.key == "impeccable" or .key == "ui-ux-pro-max" or .key == "skillui")))
' "$VERSIONES" > "$VERSIONES.tmp"
mv "$VERSIONES.tmp" "$VERSIONES"
cat "$VERSIONES"
