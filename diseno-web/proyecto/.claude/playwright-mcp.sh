#!/bin/sh
# Arranca Playwright MCP para este proyecto (lo agrega claude-skills/diseno-web).
# En tu Mac usa Chrome como siempre. En las sesiones de Claude en la nube no
# hay Chrome: usa el Chromium que ya viene instalado ahí, sin ventana.
if [ -x /opt/pw-browsers/chromium ] && ! command -v google-chrome >/dev/null 2>&1; then
  exec npx -y @playwright/mcp@latest --headless --isolated --no-sandbox \
    --executable-path /opt/pw-browsers/chromium "$@"
fi
exec npx -y @playwright/mcp@latest "$@"
