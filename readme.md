[![Netlify Status](https://api.netlify.com/api/v1/badges/c513a722-6826-4a47-b022-c4a8b987ee00/deploy-status)](https://app.netlify.com/sites/peaceful-jepsen-c4fa03/deploys)

# axy.one

My personal site — musings, work, and posts — at **[axy.one](https://axy.one)**.

A statically generated [Jekyll](https://jekyllrb.com/) site with a custom,
monospace design built on Tailwind CSS v4 and set in GitHub's
[Monaspace](https://monaspace.githubnext.com/). No theme gem — every layout,
style, and include lives in this repo. Dark by default, light on toggle, and
fully functional with JavaScript disabled.

## Stack

| Concern | Tool |
|---|---|
| Site generator | Jekyll 4 (Ruby) |
| Styling | Tailwind CSS v4 via `@tailwindcss/cli` |
| Type | Monaspace (Neon + Radon) via `@fontsource/*` |
| Icons | `lucide-static` (UI) + `@fortawesome/fontawesome-free` (brands), inlined as SVG |
| Feeds | `jekyll-feed` (`/feed.xml`, `/work/feed.xml`) |
| Hosting | Netlify (short links via `_redirects`) |

It's a **two-toolchain build**: Ruby/Bundler runs Jekyll; npm vendors the fonts
and icons and compiles the CSS. Generated assets (CSS, fonts, icons) are
gitignored and rebuilt on every build.

## Requirements

- **Ruby** — pinned in [`.ruby-version`](.ruby-version) (currently `3.4.9`).
  Version managers (rvm, rbenv, chruby) and Netlify pick it up automatically.
- **Node** — pinned in [`.nvmrc`](.nvmrc) (currently `26`). With
  [nvm](https://github.com/nvm-sh/nvm), `nvm install` / `nvm use` reads the pin.
- **OpenSSL 3.x** — required to build Ruby 3.x from source. On macOS:

  ```sh
  brew install openssl@3
  ```

  If you install Ruby with rvm and the build fails on the `openssl` extension
  (it defaults to the EOL openssl@1.1), point it at OpenSSL 3 explicitly:

  ```sh
  rvm install "$(cat .ruby-version)" --with-openssl-dir="$(brew --prefix openssl@3)"
  ```

## Getting started

```sh
bundle install && npm install         # first time / after Gemfile or package.json changes
npm run dev                           # vendor + Tailwind --watch + jekyll serve → localhost:4000
JEKYLL_ENV=production npm run build   # full production build into _site/
```

`npm run build` runs the whole pipeline: vendor fonts + icons from npm → compile
Tailwind → `jekyll build`. A bare `jekyll build` uses stale/missing generated
assets, so always go through the npm scripts. `_config.yml` is not reloaded by
`jekyll serve` — restart the server after editing it.

## Structure

```
_layouts/    page templates (default shell, home, list, post, project)
_includes/   partials (sidebar, cards, chips, icon wrapper, …) + generated icons/
_posts/      blog posts        → /posts/<slug>
_work/       project entries   → /work/<slug>
_data/       nav.yml, social.yml
_plugins/    archive generator + build-time guards, category/email helpers
_tailwind/   Tailwind source CSS + @theme design tokens
scripts/     font + icon vendoring (Node ESM)
_redirects   Netlify short links (/linkedin, /github, …), copied verbatim via include:
```

## Docs

- **[CLAUDE.md](CLAUDE.md)** — build pipeline, content model, routing, and conventions.
- **[DESIGN.md](DESIGN.md)** — the design system: color tokens, typography, components, accessibility.

## Deployment

Pushed to Netlify, which runs `JEKYLL_ENV=production npm run build` (installing
both Bundler and npm deps first) and publishes `_site/`. `main` is protected —
changes land via pull request, and every PR gets a deploy preview.

## License

Content and code are licensed under
[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).
