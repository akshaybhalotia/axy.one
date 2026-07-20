#!/usr/bin/env ruby
# frozen_string_literal: true

# Output smoke test: asserts a handful of high-signal invariants on the built
# _site that a passing build + Lighthouse won't catch — the "valid but wrong
# output" class of regression (e.g. the SEO default share card leaking into a
# post body, #27). Run in CI after the build. Usage: ruby check-output.rb [_site]
require "nokogiri"

site = ARGV[0] || "_site"
errors = []
add = ->(where, msg) { errors << "#{where}: #{msg}" }

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
  if doc.css("img").any? { |img| img["src"].to_s.include?("og-default") }
    add.call(page, "default share card rendered as an <img> (should be og:image only)")
  end
end

# --- site-level SEO artifacts ---
sitemap = File.join(site, "sitemap.xml")
add.call("sitemap.xml", "missing")            unless File.exist?(sitemap)
add.call("sitemap.xml", "no <url> entries")   if File.exist?(sitemap) && !File.read(sitemap).include?("<url>")

robots = File.join(site, "robots.txt")
add.call("robots.txt", "missing")             unless File.exist?(robots)
add.call("robots.txt", "no Sitemap: line")    if File.exist?(robots) && !File.read(robots).include?("Sitemap:")

if errors.empty?
  puts "check-output: ✓ #{pages.size} pages passed"
else
  warn "check-output: ✗ #{errors.size} failure(s):"
  errors.each { |e| warn "  - #{e}" }
  exit 1
end
