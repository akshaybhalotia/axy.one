# frozen_string_literal: true

# Post-build output guard. After Jekyll writes _site, assert a few high-signal
# invariants on the *rendered* HTML that a green build otherwise won't catch —
# the "valid but wrong output" class of regression (e.g. the SEO default share
# card leaking into a post body as a visible <img>, #27).
#
# This runs inside the build (a :site, :post_write hook — the last hook, after
# every file is on disk), so it fails loudly on `npm run build` locally as well
# as in CI/Netlify, exactly like the other guards here (see archive_generator.rb).
# A Generator can't do this: it runs before rendering, so it never sees the final
# HTML. Link/image/HTML validity is a separate concern, left to html-proofer in CI.
require "nokogiri"

Jekyll::Hooks.register :site, :post_write do |site|
  errors = []

  # Identify the default share card the same way seo_image.rb and the templates
  # do — by site.default_image — so renaming it can't make the #27 guard below
  # silently pass. Its absence is itself a misconfiguration (head.html relies on it).
  default_image = site.config["default_image"]
  default_card = File.basename(default_image) if default_image
  errors << "_config.yml: no default_image (the #27 guard needs it)" if default_card.nil?

  Dir.glob(File.join(site.dest, "**", "*.html")).each do |file|
    page = file.sub(%r{\A#{Regexp.escape(site.dest)}/?}, "/")
    doc  = Nokogiri::HTML(File.read(file))

    # SEO meta is present and singular.
    og = doc.css('meta[property="og:image"]')
    errors << "#{page}: missing og:image"          if og.empty?
    errors << "#{page}: #{og.size} og:image tags"  if og.size > 1
    errors << "#{page}: missing rel=canonical"     if doc.at('link[rel="canonical"]').nil?
    errors << "#{page}: missing meta description"   if doc.at('meta[name="description"]').nil?

    card = doc.at('meta[name="twitter:card"]')&.[]("content")
    errors << "#{page}: twitter:card=#{card.inspect}, want summary_large_image" unless card == "summary_large_image"

    # #27 regression guard: the default share card is og:image-only and must
    # NEVER be rendered as a visible <img> (post hero, card, etc.).
    if default_card && doc.css("img").any? { |img| img["src"].to_s.include?(default_card) }
      errors << "#{page}: default share card (#{default_card}) rendered as an <img> (should be og:image only)"
    end
  end

  # Site-level SEO artifacts: each file must exist and contain its marker.
  { "sitemap.xml" => "<url>", "robots.txt" => "Sitemap:" }.each do |name, needle|
    path = File.join(site.dest, name)
    if !File.exist?(path)
      errors << "#{name}: missing"
    elsif !File.read(path).include?(needle)
      errors << "#{name}: no #{needle.inspect} marker"
    end
  end

  unless errors.empty?
    raise "axy output: #{errors.size} validation failure(s):\n" +
          errors.map { |e| "  - #{e}" }.join("\n")
  end
end
