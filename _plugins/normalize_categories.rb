# Jekyll auto-splits a string `categories` into an array for posts, but not for
# other collections. Normalize every document so a string value ("web design")
# becomes an array (["web", "design"]) everywhere — generator and templates alike.
Jekyll::Hooks.register :documents, :post_init do |doc|
  cats = doc.data["categories"]
  doc.data["categories"] = cats.split if cats.is_a?(String)
end
