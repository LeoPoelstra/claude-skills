<!-- diseno-web:inicio (lo agrega claude-skills/diseno-web; para cambiarlo editá el repo y corré actualizar.sh) -->
## Diseño web (siempre que te pida una web, webapp, landing, sitio, dashboard o cualquier interfaz HTML)

Seguí este proceso sin que te lo tenga que pedir:

1. **Contexto.** Si no queda claro qué es, para quién es y qué estilo busco, preguntame lo mínimo en un solo mensaje. Si no hay carpeta de proyecto, creá una en ~/Proyectos/<nombre>.
2. **Referencia (opcional).** Si te paso una web de referencia, corré `npx skillui --url <url> --out <carpeta temporal>` y usá solo su lenguaje visual (colores, tipografía, espaciados, densidad). Nunca la copies.
3. **Sistema de diseño.** Usá la skill ui-ux-pro-max con `--design-system --persist --output-dir <raíz del proyecto>`. Mostrame un resumen corto (estilo, paleta, tipografías, componentes clave) y esperá mi OK antes de programar, salvo que te haya dicho "hacelo directo".
4. **Construcción.** Cargá la skill impeccable antes de escribir código y seguí sus reglas. Si te pide contexto (PRODUCT.md), crealo vos con lo que te conté; no me hagas correr comandos.
5. **Auditoría.** Pasá impeccable `audit` y `critique` sobre lo que hiciste, corregí lo importante y terminá con `polish`.
6. **Prueba real.** Abrí la página con Playwright (archivo local o servidor local) en escritorio y en celular (375px). Probá navegación, botones, formularios, links, menús, estados vacíos y errores, y revisá que la consola no tenga errores. Corregí y volvé a probar hasta que los flujos principales anden.
7. **Cierre.** Recién ahí decime que está listo, con un resumen corto de qué probaste y qué corregiste.

Estilo por defecto si no digo otra cosa: fondo claro, sans serif, un solo color de acento, mucho espacio en blanco, cards solo cuando aporten estructura, sin gradientes genéricos.

No apliques este proceso a mails HTML (bloques de SendGrid, dedicated sends) ni a las tareas automáticas del mail (Mesa de Entrada / TM-FGB).

Si te pido "actualizá mis herramientas de diseño web", corré `bash ~/claude-skills/diseno-web/actualizar.sh`.
<!-- diseno-web:fin -->
