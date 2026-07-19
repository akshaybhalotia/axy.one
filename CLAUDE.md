# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`axy.one` is Akshay Bhalotia's personal blog/site — a static [Jekyll](https://jekyllrb.com/) 4.x site with a **custom design built on Tailwind CSS v4** (no theme gem), set in **Monaspace**, deployed to **Netlify** (site `peaceful-jepsen-c4fa03`).

This file covers **build, architecture, and conventions**. For the **design system** (color tokens, typography, components, patterns, a11y), see **`DESIGN.md`** — the design source of truth.

> The site was rebuilt from the stock `minima` theme into this custom Jekyll + Tailwind stack. There is **no `minima`/theme gem** anymore; all layouts, styles, and includes live in this repo.

## Commands

```bash
bundle install                              # gems (first time / after Gemfile changes)
bundle exec jekyll serve                    # dev server + live reload at http://localhost:4000
JEKYLL_ENV=production bundle exec jekyll build   # production build into _site/ (Netlify runs this)
```

- **Ruby 3.4.9** (pinned in `.ruby-version`), installed via `rvm`. If a fresh rvm build fails on OpenSSL, rebuild with `--with-openssl-dir=$(brew --prefix openssl@3)`.
- **Single command builds everything** — the Tailwind step runs *inside* the Jekyll build (see below), so `jekyll serve`/`build` also (re)compiles CSS. No Node, no separate watcher.
- `_config.yml` is **NOT reloaded** on `jekyll serve` — restart the server after editing it.

## Build pipeline — Tailwind v4, no Node (`_plugins/tailwind.rb`)

- Source CSS lives at **`_tailwind/app.css`** (underscore dir → ignored by Jekyll). It compiles to **`assets/css/main.css`**, which Jekyll then serves as a static file.
- The plugin registers a `Jekyll::Hooks :site, :after_reset` hook (fires on **every** (re)build, so `jekyll serve` recompiles on change). It runs the **Tailwind v4 standalone binary** (a single self-contained executable — no npm) with `--minify` when `JEKYLL_ENV == "production"`.
- The binary is **version-pinned + checksum-verified** (`VERSION = "v4.3.1"`, per-platform SHA256). If `bin/tailwindcss` is missing it downloads the correct platform build (macos-arm64 locally, linux-x64 on Netlify) and verifies the checksum before use.
- **Both `bin/tailwindcss` and `assets/css/main.css` are gitignored build artifacts** — never commit or hand-edit them. To bump Tailwind, change `VERSION` and the matching checksums in this plugin.

## Content model — collections & front matter

`_config.yml` defines two collections with per-type default layouts:

| Collection | Dir | Permalink | Layout |
|---|---|---|---|
| Posts | `_posts/` (`YYYY-MM-DD-title.markdown`) | `/posts/:title` | `post` |
| Work | `_work/` | `/work/:name` | `project` |

Front-matter fields:

- **Posts:** `title`, `subtitle`, `author`, `date`, `categories: [..]`, `featured: true` (→ Home row), optional `image` (card/hero).
- **Work (projects):** `title`, **`hero`** (required — build fails without it), `date`, `categories`, `client`, `for`, optional `image`.
- Type is **collection membership** (`_posts` vs `_work`) — there is no separate `type:` field.

Top-level pages are Markdown/HTML at the repo root (`index.markdown`, `contact.md`, `404.html`) and the collection index pages (`posts/index.html`, `work/index.html`, both `layout: list`).

## Generated routes & build-time guards (`_plugins/`)

- **`archive_generator.rb`** (a `Jekyll::Generator`): for each of `work`/`posts` it
  - derives **`site.data.category_index[<collection>]`** (deduped by slug) used to render the category pills;
  - emits a `PageWithoutAFile` per category (`/work|posts/<category>`) and per date (`/work|posts/<YYYY-MM-DD>`, unlinked but reachable), all `layout: list`;
  - **validates and fails the build loudly** on: a `_work` item missing `hero`, an unparseable/missing `date`, or a slug that **collides** with a category or date within the same collection. On a collision, resolve the content — don't silence the guard.
- **`normalize_categories.rb`** (`:documents, :post_init` hook): splits a string `categories:` into an array so templates can rely on a list.
- **`obfuscate_email.rb`**: registers the `obfuscate_email` Liquid filter (hex HTML entities). The site email is deliberately kept **out of the RSS feed** (`author.email` omitted in `_config.yml`); the Contact page + sidebar use the obfuscated top-level `email`.

## Layouts, includes & data

- **`_layouts/`**: `default.html` (shell: sidebar + main + footer, theme/nav toggles, head), `home.html`, `list.html` (shared by `/work`, `/posts`, and generated category/date pages via `page.filter_type`/`page.filter_value`), `post.html`, `project.html`.
- **`_includes/`**: `sidebar.html`, `icon.html` (single-path `currentColor` glyphs), `category-chip.html`, `category-list.html`, `list-card.html`, `featured-card.html`, `ext-link.html` (canonical external/new-tab link — see DESIGN.md §5).
- **`_data/`**: `nav.yml` (nav items; `new_tab: true` for off-site), `social.yml` (full brand-colored set for the Contact page; sidebar shows only email + GitHub, monochrome).

## Fonts

**Monaspace** (Neon body/code, Radon display) is **self-hosted** — the woff2 files in `assets/fonts/` are **committed** (not gitignored) as the fallback, with the `fontsource` CDN (`@latest`) as the primary `src` in each `@font-face`. See DESIGN.md §3 for the loading strategy and rationale.

## Redirects (Netlify, not Jekyll)

Short links (`/linkedin`, `/github`, `/resume`, `/twitter`, …) live in **`_redirects`** as plain `from → to` mappings consumed by Netlify. `_config.yml` has `include: [_redirects]` so Jekyll copies it verbatim into `_site/`. **To add a short link, edit `_redirects`** — do not create a redirect page. The Contact page is a real route (`contact.md`), not a redirect.

## RSS

`jekyll-feed` generates the posts feed at **`/feed.xml`** plus a work feed at **`/work/feed.xml`** (`feed.collections.work.path`). `{% feed_meta %}` in `<head>` enables autodiscovery; a visible RSS link is in the footer. RSS is a first-class requirement — keep feeds valid when touching content/config.

## Theming & no-JS

The site is **no-JS-first**: the nav and theme toggles are CSS checkboxes (`#nav-toggle`, `#theme-toggle`) driven by `:checked`, `:has()`, and `~`. JS only *enhances* — theme persistence (a no-flash `<head>` script using `localStorage` + `prefers-color-scheme`) and the hero typewriter. Everything degrades to a complete static experience. Details in DESIGN.md §6.

## Deployment & CI

- **Netlify** (`netlify.toml`): build command `JEKYLL_ENV=production bundle exec jekyll build`, `publish = "_site"`, `RUBY_VERSION = "3.4.9"`. Deploy previews run on PRs.
- **CI** (`.github/workflows/build.yml`): runs the production build on PRs/pushes to `main` (Ruby 3.4.9, bundler cache, caches the pinned Tailwind binary). Note: GitHub only activates a workflow once it exists on the **default branch**.
- **`main` is protected** (ruleset: PR required, linear history) — land changes via PRs, don't push to `main` directly.

## Conventions & gotchas

- **Design changes → follow `DESIGN.md`** (tokens, components, patterns). Prefer a theme token over a hardcoded color; keep both themes AA.
- `_site/`, `bin/tailwindcss`, `assets/css/main.css`, and `.claude/` are **gitignored** build/local artifacts — never edit by hand or commit.
- `exclude:` in `_config.yml` **replaces** Jekyll's defaults, so `node_modules` and `gemfiles` are re-added explicitly there — keep them if you touch `exclude:`.
- `CLAUDE.md` and `DESIGN.md` have no front matter, so Jekyll copies them **verbatim** to `_site/` (they ship as raw files at `/CLAUDE.md`, `/DESIGN.md`). Add to `exclude:` if that's ever unwanted.
- Site-wide variables (title, email, social usernames, author) live in `_config.yml` (`{{ site.title }}`, `{{ site.email }}`, …).
