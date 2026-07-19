<!-- PROJECT LOGO -->
<p align="center">
  <a href="https://axy.one">
    <img src="assets/img/avatar.png" alt="axy.one" width="80">
  </a>

  <h2 align="center">axy.one</h2>

  <p align="center">
    Personal site for Akshay Bhalotia
    <br />
    <br />
    <a href="https://axy.one">View</a>
    ·
    <a href="https://github.com/akshaybhalotia/axy.one/issues">Report Bug</a>
    ·
    <a href="https://github.com/akshaybhalotia/axy.one/issues">Request Feature</a>
  </p>
</p>

<div align="center">

[![Build](https://github.com/akshaybhalotia/axy.one/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/akshaybhalotia/axy.one/actions/workflows/build.yml)
[![Release](https://github.com/akshaybhalotia/axy.one/actions/workflows/release-please.yml/badge.svg?branch=main)](https://github.com/akshaybhalotia/axy.one/actions/workflows/release-please.yml)
[![Link check](https://github.com/akshaybhalotia/axy.one/actions/workflows/link-check.yml/badge.svg)](https://github.com/akshaybhalotia/axy.one/actions/workflows/link-check.yml)
[![Netlify Status](https://api.netlify.com/api/v1/badges/c513a722-6826-4a47-b022-c4a8b987ee00/deploy-status)](https://app.netlify.com/sites/peaceful-jepsen-c4fa03/deploys)
[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

</div>

<!-- TABLE OF CONTENTS -->

## Table of Contents

- [About the Project](#about-the-project)
  - [Built With](#built-with)
- [Getting Started](#getting-started)
  - [Dependencies](#dependencies)
  - [Installing](#installing)
  - [Usage](#usage)
    - [Run locally](#run-project-locally)
    - [Run tests](#run-tests)
    - [Build for distribution](#build-for-distribution)
    - [Server distribution](#instructions-to-serve-distribution-build)
- [Versioning](#versioning)
  - [Version History](#version-history)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Support](#support)
- [Credits](#credits)
- [License](#license)
- [Acknowledgments](#acknowledgments)
- [About Authors](#about-authors)

<!-- ABOUT THE PROJECT -->

## About The Project

`axy.one` is Akshay Bhalotia's personal site — a place for musings, work, and
posts at **[axy.one](https://axy.one)**. It's a statically generated
[Jekyll](https://jekyllrb.com/) site with a custom, monospace design built on
Tailwind CSS v4 and set in GitHub's [Monaspace](https://monaspace.githubnext.com/).
There's no theme gem — every layout, style, and include lives in this repo. It's
dark by default, light on toggle, and fully functional with JavaScript disabled.

For a deeper look, see [`CLAUDE.md`](./CLAUDE.md) (build pipeline, content model,
routing, conventions) and [`DESIGN.md`](./DESIGN.md) (the design system).

### Built With

- [Jekyll](https://jekyllrb.com/) (Ruby) — static site generator
- [Tailwind CSS v4](https://tailwindcss.com/) via `@tailwindcss/cli`
- [Monaspace](https://monaspace.githubnext.com/) (Neon + Radon) via `@fontsource/*`
- [lucide-static](https://lucide.dev/) + [Font Awesome](https://fontawesome.com/) — icons (inlined SVG)
- [Netlify](https://www.netlify.com/) — hosting & deploy previews
- :heart: + :smoking:

<!-- GETTING STARTED -->

## Getting Started

This is a **two-toolchain build**: Ruby/Bundler runs Jekyll; npm vendors the
fonts and icons and compiles the CSS. Generated assets (CSS, fonts, icons) are
gitignored and rebuilt on every build. To get a local copy running, follow the
steps below.

## Dependencies

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

## Installing

1. Clone the repo

   ```sh
   git clone https://github.com/akshaybhalotia/axy.one.git
   cd axy.one
   ```

2. Install both toolchains' dependencies

   ```sh
   bundle install && npm install
   ```

<!-- USAGE EXAMPLES -->

## Usage

`npm run build` runs the whole pipeline: vendor fonts + icons from npm → compile
Tailwind → `jekyll build`. A bare `jekyll build` uses stale/missing generated
assets, so always go through the npm scripts. `_config.yml` is not reloaded by
`jekyll serve` — restart the server after editing it.

### Run project locally

```sh
npm run dev   # vendor + Tailwind --watch + jekyll serve → http://localhost:4000
```

### Run tests

There's no unit-test suite — this is a static site. CI runs the production build
as a smoke check on every pull request; run the same check locally with:

```sh
JEKYLL_ENV=production npm run build
```

### Build for distribution

```sh
JEKYLL_ENV=production npm run build   # outputs the static site into _site/
```

### Instructions to serve distribution build

[Netlify](https://www.netlify.com/) builds and serves `_site/` on every push. To
preview the production build locally:

```sh
npx serve _site
```

<!-- CHANGELOG -->

## Versioning

This project uses [SemVer](https://semver.org/) for versioning. Each release maps
to a pull request merged into `main` and is tagged on the repository — the history
runs from `0.1.0` (the original site) up to the current `0.9.x`, with the first
stable release, `1.0.0`, following the [roadmap](#roadmap) below. For the versions
available, see the [tags on this repository](https://github.com/akshaybhalotia/axy.one/tags).

### Version History

See [CHANGELOG.md](./CHANGELOG.md).

<!-- ROADMAP -->

## Roadmap

Before the `1.0.0` release:

- Improve syntax highlighting
- SEO optimizations

See the [open issues](https://github.com/akshaybhalotia/axy.one/issues) for the
full list of proposed features (and known issues).

<!-- CONTRIBUTING -->

## Contributing

This is a personal site, but fixes and suggestions are welcome — typos, broken
links, accessibility issues, or build problems especially. Any contributions you
make are **greatly appreciated**.

Please follow the [contribution guidelines](./CONTRIBUTING.md) and the
[code of conduct](./CODE_OF_CONDUCT.md) while contributing. Sincere thanks to all
[contributors](https://github.com/akshaybhalotia/axy.one/graphs/contributors)! :smile:

## Support

Contributions, issues, and feature requests are welcome! Give a ⭐️ if you like this project!

## Credits

- [@vikxlp](https://github.com/vikxlp) — design feedback

<!-- LICENSE -->

## License

This work — the `axy.one` source **and** its content — is licensed under a
Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License
([CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)) — see the
[LICENSE](./LICENSE) file for details.

## Acknowledgments

- [Jekyll](https://jekyllrb.com/) and [Tailwind CSS](https://tailwindcss.com/)
- [Monaspace](https://monaspace.githubnext.com/) by GitHub Next — the typeface
- [Lucide](https://lucide.dev/) and [Font Awesome](https://fontawesome.com/) — icons
- [Fontsource](https://fontsource.org/) — self-hosted font packages
- [Netlify](https://www.netlify.com/) — hosting
- [Contributor Covenant](https://www.contributor-covenant.org/) — the code of conduct
- [readme-template](https://github.com/akshaybhalotia/readme-template) — this README's structure

## About Authors

`axy.one` is created & maintained by Akshay Bhalotia. You can find me on
Telegram — [@akshaybhalotia](https://t.me/akshaybhalotia) — or write to me at
`contact [at] axy.one`.
