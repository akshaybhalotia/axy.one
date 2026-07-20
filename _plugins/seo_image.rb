# frozen_string_literal: true

# jekyll-seo-tag reads `page.image` for og:image / twitter:image, and only emits the
# large `summary_large_image` twitter:card when it's set. So give EVERY page one — a
# work item's `hero` / a post's `image`, else the site-wide default share card
# (`default_image`) — for complete, large link previews. The templates that render a
# hero/card image (post.html, list-card, featured-card) skip it when it equals
# `site.default_image`, so this SEO fallback is never shown as an actual page image.
Jekyll::Hooks.register [:documents, :pages], :post_init do |item|
  data = item.data
  data["image"] ||= data["hero"] || item.site.config["default_image"]
end
