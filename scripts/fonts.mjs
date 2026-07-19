// Copies the woff2 we use from the @fontsource packages into assets/fonts/.
// Run via `npm run vendor:fonts`. The Tailwind CLI is a CSS compiler, not an
// asset bundler, so it won't move these itself — @font-face in _tailwind/app.css
// points at the copied files.
import { copyFileSync, mkdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const OUT = join(root, "assets", "fonts");

const FONTS = [
  ["@fontsource/monaspace-neon/files/monaspace-neon-latin-400-normal.woff2", "monaspace-neon-400.woff2"],
  ["@fontsource/monaspace-neon/files/monaspace-neon-latin-700-normal.woff2", "monaspace-neon-700.woff2"],
  ["@fontsource/monaspace-radon/files/monaspace-radon-latin-700-normal.woff2", "monaspace-radon-700.woff2"],
];

mkdirSync(OUT, { recursive: true });
for (const [src, dest] of FONTS) {
  copyFileSync(join(root, "node_modules", src), join(OUT, dest));
}
console.log(`fonts: copied ${FONTS.length} woff2 into assets/fonts/`);
