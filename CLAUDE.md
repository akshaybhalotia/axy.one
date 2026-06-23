# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`axy.one` is Akshay Bhalotia's personal blog/site — a static [Jekyll](https://jekyllrb.com/) 4.x site using the `minima` theme, deployed to **Netlify** (site `peaceful-jepsen-c4fa03`).

## Commands

```bash
bundle install              # install gems (first time / after Gemfile changes)
bundle exec jekyll serve    # local dev server with live reload at http://localhost:4000
bundle exec jekyll build    # build static site into _site/ (Netlify runs this)
```

Note: `_config.yml` is NOT reloaded on `jekyll serve` — restart the server after editing it.

## Architecture & key conventions

- **Content is front-matter-driven Markdown.** Pages live at the repo root (`index.markdown`, `about.markdown`, `404.html`); blog posts live in `_posts/` named `YYYY-MM-DD-title.markdown`. Each file starts with a YAML front-matter block (`layout:`, `title:`, `permalink:`) that controls rendering. Layouts/styles come from the `minima` gem, not from files in this repo.

- **Redirects are handled by Netlify, not Jekyll.** Short-link redirects (e.g. `/linkedin`, `/resume`, `/github`) are defined in `_redirects`. This file is plain `from → to` mappings consumed by Netlify. Because Jekyll would otherwise ignore it, `_config.yml` has an `include: [_redirects]` entry so the file is copied verbatim into `_site/`. **To add a short link, edit `_redirects`** — do not create a redirect page.

- **Site-wide variables** (title, email, social usernames, theme, plugins) live in `_config.yml` and are referenced in templates as `{{ site.title }}`, `{{ site.email }}`, etc.

- `_site/` and Jekyll caches are gitignored build output — never edit by hand.
