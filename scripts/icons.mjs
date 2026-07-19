// Vendors icons from npm packages into _includes/icons/*.svg (normalized, no
// width/height, currentColor, aria-hidden). Run via `npm run vendor:icons`.
// icon.html includes these and injects the size class. Never hand-edit the
// output — add/change icons in the MANIFEST below and re-run.
import { readFileSync, writeFileSync, mkdirSync, rmSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const OUT = join(root, "_includes", "icons");

// MANIFEST — the site's icon surface. set: lucide (UI, stroke) | fontawesome
// (brands, filled — Font Awesome Free's svgs/brands). `slug` overrides the
// package filename when it differs.
const ICONS = [
  { name: "email", set: "lucide", slug: "mail" },
  { name: "sun", set: "lucide" },
  { name: "moon", set: "lucide" },
  { name: "github", set: "fontawesome" },
  { name: "linkedin", set: "fontawesome" },
  { name: "instagram", set: "fontawesome" },
  { name: "stackoverflow", set: "fontawesome", slug: "stack-overflow" },
  { name: "steam", set: "fontawesome" },
  { name: "telegram", set: "fontawesome" },
  { name: "twitter", set: "fontawesome" }, // FA still ships the bird; use "x-twitter" for the X
];

const SRC = {
  lucide: (slug) => join(root, "node_modules/lucide-static/icons", `${slug}.svg`),
  fontawesome: (slug) =>
    join(root, "node_modules/@fortawesome/fontawesome-free/svgs/brands", `${slug}.svg`),
};

function normalize(svg, set) {
  const s = svg
    .replace(/<\?xml[^>]*\?>/g, "")
    .replace(/<!--[\s\S]*?-->/g, "")
    .replace(/<title>[\s\S]*?<\/title>/g, "")
    .replace(/\s+/g, " ")
    .trim();
  // Rewrite ONLY the opening <svg> tag (strip its width/height/role/class so it's
  // sized via a class; add aria-hidden; give fill-less brand logos currentColor).
  // Inner-element geometry (e.g. a <rect>'s width/height) is left untouched.
  return s.replace(/<svg\b[^>]*>/, (open) => {
    let o = open.replace(/\s(width|height|role|class)="[^"]*"/g, "");
    if (set === "fontawesome" && !/\sfill=/.test(o)) {
      o = o.replace("<svg", '<svg fill="currentColor"');
    }
    return o.replace("<svg", '<svg aria-hidden="true"');
  });
}

rmSync(OUT, { recursive: true, force: true });
mkdirSync(OUT, { recursive: true });
for (const { name, set, slug } of ICONS) {
  const resolve = SRC[set];
  if (!resolve) throw new Error(`icons: unknown set "${set}" for "${name}"`);
  const file = resolve(slug || name);
  let svg;
  try {
    svg = readFileSync(file, "utf8");
  } catch {
    throw new Error(`icons: "${name}" not found in ${set} (expected ${slug || name}.svg)`);
  }
  writeFileSync(join(OUT, `${name}.svg`), normalize(svg, set) + "\n");
}
console.log(`icons: vendored ${ICONS.length} into _includes/icons/`);
