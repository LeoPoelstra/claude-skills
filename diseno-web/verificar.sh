#!/usr/bin/env bash
# Muestra qué herramientas de diseño web están instaladas. No cambia nada.
#
# Uso:  bash ~/claude-skills/diseno-web/verificar.sh

set -u
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

requisitos
verificar
