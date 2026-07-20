#!/usr/bin/env ruby
# frozen_string_literal: true

# Output smoke test: asserts a handful of high-signal invariants on the built
# _site that a passing build + Lighthouse won't catch — the "valid but wrong
# output" class of regression (e.g. the SEO default share card leaking into a
# post body, #27). Run in CI after the build. Usage: ruby check-output.rb [_site]
require "nokogiri"
require "yaml"

site = ARGV[0] || "_site"
errors = []
add = ->(where, msg) { errors << "#{where}: #{msg}" }

# Identify the default share card the same way the templates and seo_image.rb do
# — by site.default_image — instead of a hardcoded name, so renaming the card
# can't make the #27 guard below silently pass. Resolve _config.yml relative to
# this script so the working directory doesn't matter.
config = YAML.safe_load_file(File.expand_path("../../_config.yml", __dir__),
                             permitted_classes: [Date, Time], aliases: true)
default_card = config["default_image"] or abort "check-output: _config.yml has no default_image"
default_card = File.basename(default_card) # e.g. "og-default.png"

pages = Dir.glob(File.join(site, "**", "*.html"))
abort "check-output: no HTML found in #{site}/" if pages.empty?

pages.each do |file|
  page = file.sub(%r{\A#{Regexp.escape(site)}/?}, "/")
  doc  = Nokogiri::HTML(File.read(file))

  # --- SEO meta is present and singular ---
  og = doc.css('meta[property="og:image"]')
  add.call(page, "missing og:image")             if og.empty?
  add.call(page, "#{og.size} og:image tags")     if og.size > 1
  add.call(page, "missing rel=canonical")        if doc.at('link[rel="canonical"]').nil?
  add.call(page, "missing meta description")      if doc.at('meta[name="description"]').nil?

  card = doc.at('meta[name="twitter:card"]')&.[]("content")
  add.call(page, "twitter:card=#{card.inspect}, want summary_large_image") unless card == "summary_large_image"

  # --- #27 regression guard: the default share card is og:image-only and must
  #     NEVER be rendered as a visible <img> (post hero, card, etc.). ---
  if doc.css("img").any? { |img| img["src"].to_s.include?(default_card) }
    add.call(page, "default share card (#{default_card}) rendered as an <img> (should be og:image only)")
  end
end

# --- site-level SEO artifacts: each file must exist and contain its marker ---
{ "sitemap.xml" => "<url>", "robots.txt" => "Sitemap:" }.each do |name, needle|
  path = File.join(site, name)
  if !File.exist?(path)
    add.call(name, "missing")
  elsif !File.read(path).include?(needle)
    add.call(name, "no #{needle.inspect} marker")
  end
end

if errors.empty?
  puts "check-output: ✓ #{pages.size} pages passed"
else
  warn "check-output: ✗ #{errors.size} failure(s):"
  errors.each { |e| warn "  - #{e}" }
  exit 1
end
