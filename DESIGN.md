# DESIGN.md — axy.one design system

The source of truth for the site's visual language. Tokens live in
`_tailwind/app.css` (a Tailwind v4 `@theme` block plus a light-theme override);
this file documents what they are, why, and how to extend them without drifting.

For build/tooling and content architecture, see `CLAUDE.md`. This file is design only.

---

## 1. Principles

- **Monospace / terminal identity.** Everything is set in a monospace superfamily
  (Monaspace). The look is a maker's terminal — warm, hand-made, a little playful —
  not a corporate template.
- **Warm, not flat.** Surfaces are warm near-neutrals (never pure `#000`/`#fff`),
  so both themes feel like the same brand.
- **No-JS-first.** Every feature works with JavaScript disabled. JS only *enhances*
  (persistence, the typewriter). Toggles are CSS (`:checked`, `:has()`, `~`).
- **Restraint, one signature.** The palette is monochrome; the one deliberate
  flourish is the hero (handwriting display + typed-in headline with a cursor).
- **Accessibility is a floor, not a feature.** WCAG AA contrast minimum,
  `:focus-visible` everywhere, `prefers-reduced-motion` respected, semantic
  landmarks, skip link.

---

## 2. Color tokens

Defined as CSS custom properties. The **dark theme is the default** (`@theme`);
the **light theme** overrides the same variables under
`html:has(#theme-toggle:checked), html[data-theme="light"]`. Every component reads
these tokens, so re-theming happens in one place.

### Surfaces

| Token | Dark (default) | Light | Role |
|---|---|---|---|
| `--color-sidebar` | `#14120f` | `#f7f4ed` | Sidebar / nav rail (also the dark code box) |
| `--color-panel` | `#4f4c47` | `#e5dece` | Main content background |
| `--color-ink` | `#f7f6f4` | `#1c1a16` | Primary text on panel + sidebar |
| `--color-card` | `#e4e1db` | `#fffdf8` | Post/list/featured card background |
| `--color-card-ink` | `#1a1713` | `#1c1a16` | Card title/body text |
| `--color-card-muted` | `#4f4c47` | `#5b544a` | Card subtitle / secondary |
| `--color-code-bg` | `#14120f` | `#f4efe3` | Inline code + code block surface |
| `--color-toggle` | `#57534d` | `#d3cdc0` | Avatar menu-badge disc |

The value structure is a deliberate 3-tier ladder in both themes
(sidebar → panel → card) so surfaces stay distinct; the light theme was warmed and
its tiers widened so it doesn't crowd near-white.

### Chrome

| Token | Dark | Light | Role |
|---|---|---|---|
| `--color-focus` | `#ffffff` | `#1a1a1a` | `:focus-visible` outline |
| `--color-avatar-border` | `rgb(255 255 255 / .6)` | `rgb(0 0 0 / .5)` | Avatar ring |
| `--color-avatar-border-hover` | `#ffffff` | `#000000` | Avatar ring on hover |
| `--color-scrim` | `rgb(0 0 0 / .5)` | `rgb(0 0 0 / .45)` | Mobile menu backdrop |
| `--color-all-pill-bg` | `rgb(255 255 255 / .15)` | `rgb(0 0 0 / .08)` | Avatar "AB" fallback bg |
| `--color-social-border` | `transparent` | `rgb(0 0 0 / .18)` | Contact social badge border |

There is intentionally **no accent hue** and **no per-category color** — interactive
state is carried by underline / inversion / opacity, not color.

### Verified contrast (WCAG)

| Pair | Dark | Light |
|---|---|---|
| ink on panel (body) | 7.9:1 | 13:1 |
| ink on sidebar (nav) | 17.3:1 | 15.8:1 |
| card-ink on card | 13.7:1 | 17:1 |
| muted on card | 6.6:1 | 7.4:1 |
| ink on code surface | 17.3:1 | 15.1:1 |

Body/UI text must meet **4.5:1**; large text **3:1**. Re-check any surface/ink change.

---

## 3. Typography

Two roles from GitHub's **Monaspace** superfamily (SIL OFL, self-hosted from the
`@fontsource` npm packages):

| Role | Family | Token | Weights |
|---|---|---|---|
| Body / code / nav / UI | **Monaspace Neon** (neo-grotesque mono) | `--font-mono` | 400, 700 |
| Display / headings | **Monaspace Radon** (handwriting mono) | `--font-head` | 700 |

`--default-font-family` = `--font-mono`. Headings opt into the display face with the
`font-head` utility class (which also applies `letter-spacing: -0.01em`). Applied to
the hero `h1`, page-title `h1`s, and the large section `h2`s — **not** card titles or
in-body markdown headings (those stay Neon).

### Loading

- **Self-hosted from npm.** `scripts/fonts.mjs` (`npm run vendor:fonts`) copies the
  woff2 out of the `@fontsource/monaspace-*` packages into `assets/fonts/`
  (gitignored, generated); `@font-face` in `_tailwind/app.css` points at those local
  files. Versioned via `package.json`, no runtime CDN.
- `<head>` `preload`s the two above-the-fold faces (Neon 400, Radon 700); all faces
  use `font-display: swap`.
- Vendored files are latin-only woff2: `monaspace-neon-400`, `monaspace-neon-700`,
  `monaspace-radon-700`.

### OpenType

- **Texture healing on everywhere:** `:root { font-feature-settings: "calt" 1 }`.
- **Coding ligatures only in code:** `.rich code, .rich pre` enable
  `"calt","liga","ss01"…"ss08"` so `== => != ->` render as ligatures where they mean
  something. Prose never gets coding ligatures.

### Type scale (Tailwind sizes)

| Use | Classes | px |
|---|---|---|
| Hero / page title `h1` | `text-2xl xs:text-3xl desk:text-[2.5rem]` bold | 24 → 30 → 40 |
| Section `h2` | `text-2xl desk:text-3xl` bold | 24 → 30 |
| Body prose (`.rich`) | `text-lg` | 18 |
| `.rich h2` / `.rich h3` | 1.5rem / 1.25rem, 700 | 24 / 20 |
| Nav links | `text-xl` bold | 20 |
| List-card title | `text-lg desk:text-xl` bold | 18 → 20 |
| Card subtitle / meta | `text-sm` (+ `text-ink/70` for meta) | 14 |
| Footer | `text-xs` | 12 |

---

## 4. Layout & spacing

- **Shell** (`.app-shell`): flex row on desktop, column on mobile.
- **Sidebar** (`.app-sidebar`): on desktop `position: fixed`, full-height (`100dvh`),
  pinned — it never scrolls; the page scrolls with the **single browser scrollbar**.
  Width is fluid, shared via one variable so the sidebar, the main offset, and the
  inner panel can't drift:
  - `--sidebar-w: clamp(14rem, 16vw, 16rem)` → **224px** ≤1400, fluid 16vw, **256px** ≥1600.
- **Main** (`.app-main`): `margin-left: var(--sidebar-w)`; a flex column with
  `min-height: 100dvh` so the footer can pin to the bottom (`margin-top: auto`).
- **Reading column** (`.app-main-inner`): `max-width: 42rem`, centered; `margin-bottom:
  3.5rem` keeps the footer separator clear of content on long pages. The **footer**
  spans full main width (not the reading column) so its statement fits one line.
- **Avatar** scales with the sidebar: `clamp(5rem, 6vw, 7rem)` (~30–40% of it).
- **Breakpoints:** `--breakpoint-xs: 414px`, `--breakpoint-desk: 1024px`. Below 1024
  the desktop sidebar becomes the **mobile dropdown**; desktop nav **defaults open**.
- **Radii:** `--radius-pill: 8px` (chips), `--radius-card: 20px` (cards).
- **Shadow:** `--shadow-card: 0 4px 4px 0 rgb(0 0 0 / .25)`.

---

## 5. Components

Each lists its markup source and key behavior.

### Nav (`_includes/sidebar.html`, `.nav-link`)
Left-aligned, bold, `text-xl`. Hover = underline (offset 4, decoration 2), not a color
change. Items come from `_data/nav.yml`; `new_tab: true` items get the external arrow
(see below). The nav block is vertically centered in the fixed sidebar.

### Avatar toggle (`_layouts/default.html`, `.app-avatar` + `.app-menu-badge`)
The avatar is a `<label for="nav-toggle">` — it *is* the menu control (no JS). A
soft translucent badge (`--color-toggle`) shows an **animated hamburger ⇄ X** that
firms up on hover/focus. State is inverted per breakpoint: mobile shows ☰ when closed;
desktop (open by default) shows ✕ when open, ☰ when collapsed. Collapse animates the
sidebar width + main margin together.

### Theme toggle (`.app-theme-toggle`)
A `<label for="theme-toggle">` with sun/moon glyphs (top-right). Pure CSS via
`html:has(#theme-toggle:checked)`; a head script mirrors it to `[data-theme]` for
persistence (see §6). Default follows OS `prefers-color-scheme`.

### Category chips (`_includes/category-chip.html`, `category-list.html`, `.chip`)
**Monochrome outline** pills: hairline `ink`-toned border + ink text, a muted `#`
prefix via `::before` (the "All" scope pill has none). The **active** filter (a
category page, or "All" on the unfiltered list) **inverts** to a solid ink fill. No
per-category color.

### Cards (`_includes/list-card.html`, `featured-card.html`)
- **List card:** wide, `min-h-[11rem]`, text block + optional full-height image on the
  right; meta (author · date) pinned to the bottom. Blurb = `subtitle | default: excerpt`.
- **Featured card:** fixed `240×240` square, optional image on top + title + clamped
  blurb; used in the Home "Featured posts" row.
- Cards carry `--shadow-card`; in light mode a hairline border keeps white cards off
  the light panel.

### Footer / colophon (`_layouts/default.html`, `.app-footer`)
One `text-xs` statement, full main width, pinned to the bottom via `margin-top:auto`:
`Built with Jekyll↗ + Tailwind↗ + ❤️ + 🚬 · set in Monaspace↗ · CC BY-NC-SA 4.0↗ ·
RSS↗ · Source↗ · Last built <date>`. All links are external (see below). Licensed
**CC BY-NC-SA 4.0** (no copyright line). A hairline `border-top` separates it.

### External / new-tab links (`_includes/ext-link.html`, `.ext-arrow`)
The canonical pattern for anything opening off-site: `target="_blank"`,
`rel="noopener"`, a **dotted diagonal ↗** (`.ext-arrow`, inline SVG in `currentColor`
so it adapts to theme), and an sr-only "(opens in a new tab)". Use the `ext-link`
include for standalone links; the nav applies `.ext-arrow` to `new_tab` items.
Icon-only social links opt out.

### Code (`.rich code`, `.rich pre`)
Theme-aware surface `--color-code-bg` (near-black box in dark, warm near-white in
light) + a hairline border, so both the box and its text stay crisp in both themes.
Coding ligatures on (see §3).

### Sidebar socials vs Contact page
Sidebar keeps two **monochrome** essentials (email + GitHub). The full, brand-colored,
labelled set lives on the **Contact** page — the only place brand color appears.

### Skip link & focus (`.skip-link`, `:focus-visible`)
A visible-on-focus skip link jumps to `#main-content`. Every interactive control shows
a 2px `--color-focus` outline on `:focus-visible`.

---

## 6. Patterns & conventions

- **No-JS toggles:** `#nav-toggle` / `#theme-toggle` checkboxes drive state via
  `:checked`, `:has()`, and `~`. Collapsed nav is pulled from the a11y tree with
  `visibility: hidden`.
- **Theme persistence (progressive enhancement):** a tiny `<head>` script sets
  `[data-theme]` from `localStorage` (falling back to `prefers-color-scheme`) before
  paint (no flash), and keeps the checkbox + `[data-theme]` in sync. Without JS, the
  checkbox alone works (no persistence).
- **Hero signature:** a CSS blinking block cursor (`.hero-caret`, `step-end` blink)
  plus a JS typewriter that types the headline in at ~62ms/char. No-JS and
  reduced-motion show the full headline + cursor; the script sets `aria-label` so
  screen readers get the whole heading.
- **External links** always follow the §5 external pattern.
- **Ligatures** only in code; **color** never encodes categories.
- **Motion:** everything under `@media (prefers-reduced-motion: reduce)` drops
  transitions/animations (sidebar slide, avatar resize, cursor blink, typewriter).

---

## 7. Accessibility checklist

- Contrast ≥ 4.5:1 (text) / 3:1 (large) — see §2 table; re-verify on color changes.
- `:focus-visible` outline on all controls (`--color-focus`).
- `prefers-reduced-motion` honored.
- Semantic landmarks: `<nav aria-label>` (Primary / Social), `<main id="main-content">`,
  `<footer>`; skip link to content.
- Icons are `aria-hidden`; external links carry an sr-only "(opens in a new tab)".
- Tap targets ≥ ~44px where practical (nav `py`, chip `min-h`).

---

## 8. How to extend

- **Add/adjust a color:** edit the token in `@theme` (dark) **and** the light-theme
  block; keep it AA against its text/surface; prefer a token over a hardcoded value.
- **Add an external link:** use the `ext-link` include (or `.ext-arrow` + `target="_blank"
  rel="noopener"` + sr-only). Don't hand-roll a new arrow.
- **Add a nav item:** edit `_data/nav.yml` (`new_tab: true` for off-site).
- **Add a category:** nothing to style — chips are monochrome and derived automatically.
- **Add an icon:** add it to the MANIFEST in `scripts/icons.mjs` (set `lucide` for UI
  or `fontawesome` for brands), then `npm run vendor:icons`. Never hand-edit
  `_includes/icons/`. Use it via `{% include icon.html name="…" class="…" %}`.
- **Change a typeface:** swap the `@fontsource/*` package (+ `scripts/fonts.mjs`
  filenames), update the `@font-face` blocks + `--font-mono` / `--font-head` tokens,
  and preload the above-the-fold faces.
- **New surface/box:** reuse an existing surface token; if it needs its own, add a
  paired dark/light token like `--color-code-bg` rather than an overlay (overlays go
  muddy on one theme).
- **Never** introduce an accent hue or per-category color without revisiting §1.
