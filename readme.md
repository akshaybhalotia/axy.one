[![Netlify Status](https://api.netlify.com/api/v1/badges/c513a722-6826-4a47-b022-c4a8b987ee00/deploy-status)](https://app.netlify.com/sites/peaceful-jepsen-c4fa03/deploys)

# axy.one

Personal site, built with [Jekyll](https://jekyllrb.com/) and deployed to Netlify.

## Requirements

- **Ruby** — version is pinned in [`.ruby-version`](.ruby-version) (currently `3.4.9`).
  Version managers (rvm, rbenv, chruby) and Netlify pick this up automatically.
- **OpenSSL 3.x** — required to build Ruby 3.x from source. On macOS:

  ```sh
  brew install openssl@3
  ```

  If you install Ruby with rvm and the build fails on the `openssl` extension
  (it defaults to the EOL openssl@1.1), point it at OpenSSL 3 explicitly:

  ```sh
  rvm install "$(cat .ruby-version)" --with-openssl-dir="$(brew --prefix openssl@3)"
  ```

## Setup

```sh
gem install bundler
bundle install
```

## Local development

```sh
bundle exec jekyll serve   # http://localhost:4000, with live reload
bundle exec jekyll build   # build static site into _site/
```

Note: `_config.yml` is not reloaded by `jekyll serve` — restart the server after editing it.

## Redirects

Short links (e.g. `/linkedin`, `/resume`) live in [`_redirects`](_redirects) and are
handled by Netlify. The file is copied verbatim into the build via the `include:`
entry in `_config.yml`.
