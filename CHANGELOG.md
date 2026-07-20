# Changelog

All notable changes to [axy.one](https://axy.one) are documented here.

Versioning follows [Semantic Versioning](https://semver.org/). Each release maps
to a pull request merged into `main` and is tagged on the repository. The next
milestone, **1.0.0**, lands after the current [roadmap](./README.md#roadmap)
(syntax highlighting + SEO) ships.

## [0.10.0](https://github.com/akshaybhalotia/axy.one/compare/0.9.0...0.10.0) (2026-07-20)


### Features

* syntax highlighting for code blocks (gruvbox) ([#25](https://github.com/akshaybhalotia/axy.one/issues/25)) ([02d0dd9](https://github.com/akshaybhalotia/axy.one/commit/02d0dd94811ae8b28dd6561463a4f36afc6395c9))

## 0.9.0 — Documentation & licensing ([#20])

- Add `README.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, and this `CHANGELOG.md`, based on [readme-template](https://github.com/akshaybhalotia/readme-template).
- License the project under CC BY-NC-SA 4.0 (`LICENSE`).
- Introduce SemVer release tags and repo automation (release-please, Dependabot, PR-title lint, link check, Lighthouse, labeler).

## 0.8.0 — Includes refactor ([#19])

- Extract inlined HTML (`head`, `app-chrome`, `footer`, the social badge) into reusable includes; slim `default.html` to a thin skeleton.
- Rebuild the 404 page with design-system classes, dropping the leftover minima-era inline `<style>`.

## 0.7.0 — Full-npm toolchain ([#18])

- Move to a full npm build: Tailwind via `@tailwindcss/cli`, Monaspace via `@fontsource/*`, icons via `lucide-static` + Font Awesome.
- Pin Node 26 and single-source Node/Ruby versions through `.nvmrc` and `.ruby-version`.

## 0.6.0 — Design polish ([#17])

- Warmer palette, tighter reading width, and nav/social refinements.

## 0.5.0 — Light theme ([#16])

- Add a CSS-only light/dark theme toggle with persistence and OS-preference default.

## 0.4.0 — Contact page ([#15])

- Add the Contact page (fixes the `/contact` 404).
- Obfuscate the contact email against scrapers and drop the author email from the RSS/Atom feed.

## 0.3.0 — Accessibility & CI ([#14])

- Accessibility pass: landmarks, focus states, contrast, and reduced-motion.
- Add the production-build CI check on pull requests.

## 0.2.0 — Custom redesign ([#12])

- Rebuild the site from the Figma design on Jekyll + Tailwind CSS v4, replacing the `minima` theme: custom layouts, collapsible sidebar, cards, category chips, the archive generator with build-time guards, and RSS feeds for posts and work.

## 0.1.0 — Initial site

- The original `minima`-based Jekyll site: posts, redirects, résumé link, and base configuration.

[#20]: https://github.com/akshaybhalotia/axy.one/pull/20
[#19]: https://github.com/akshaybhalotia/axy.one/pull/19
[#18]: https://github.com/akshaybhalotia/axy.one/pull/18
[#17]: https://github.com/akshaybhalotia/axy.one/pull/17
[#16]: https://github.com/akshaybhalotia/axy.one/pull/16
[#15]: https://github.com/akshaybhalotia/axy.one/pull/15
[#14]: https://github.com/akshaybhalotia/axy.one/pull/14
[#12]: https://github.com/akshaybhalotia/axy.one/pull/12
