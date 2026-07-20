# frozen_string_literal: true

# jekyll-seo-tag reads `page.image` for og:image / twitter:image. Work items carry
# their share image as `hero` and posts as `image`; this maps whichever exists onto
# `image` so every page gets a rich preview, falling back to the site-wide default
# share card (`default_image` in _config.yml). A page's own `image` always wins.
Jekyll::Hooks.register [:documents, :pages], :post_init do |item|
  data = item.data
  data["image"] ||= data["hero"] || item.site.config["default_image"]
end
