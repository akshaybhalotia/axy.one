# Liquid filter that encodes a string as hex HTML entities at build time, so a
# literal email address never appears in the page source (defeats naive email
# harvesters that regex the raw HTML). Browsers decode the entities transparently,
# so links stay clickable, copyable, and screen-reader correct — no JavaScript.
#
#   {{ site.email | obfuscate_email }}                      -> visible text
#   {{ site.email | prepend: "mailto:" | obfuscate_email }} -> href (hides "mailto:" + address)
module ObfuscateEmail
  def obfuscate_email(input)
    input.to_s.each_char.map { |c| "&#x#{c.ord.to_s(16)};" }.join
  end
end

Liquid::Template.register_filter(ObfuscateEmail)
