# Generates flat filtered list pages for each collection:
#   /work/<category>,  /posts/<category>
#   /work/<YYYY-MM-DD>, /posts/<YYYY-MM-DD>   (hidden "by date" feature)
#
# Guards (fail the build loudly):
#   - every `work` item must define a non-empty `hero`
#   - no item slug may collide with a category slug or date in the same
#     collection (they share the /work|posts/<x> URL segment)
module AxyArchives
  class Generator < Jekyll::Generator
    safe false
    priority :low

    COLLECTIONS = {
      "work"  => { base: "work",  prefix: "Work"  },
      "posts" => { base: "posts", prefix: "Posts" },
    }.freeze

    def generate(site)
      index = {}
      COLLECTIONS.each do |name, cfg|
        coll = site.collections[name]
        next if coll.nil? || coll.docs.empty?
        docs = coll.docs

        validate_heroes!(name, docs) if name == "work"
        validate_dates!(name, docs)

        slugs = docs.map { |d| slug_of(d) }
        cats = distinct_categories(docs) # [{ "slug" =>, "label" => }], unique by slug
        dates = docs.map { |d| date_of(d) }.compact.uniq

        validate_collisions!(name, slugs, cats.map { |c| c["slug"] }, dates)

        # Pill list for list.html: derived once here (proper flatten/dedupe in Ruby
        # rather than a fragile join/split in Liquid).
        index[name] = cats.map { |c| c.merge("url" => "/#{cfg[:base]}/#{c['slug']}") }

        cats.each do |c|
          site.pages << filter_page(site, name, cfg, "category", c["slug"],
                                    "#{cfg[:prefix]} · #{c['label']}")
        end
        dates.each do |date|
          site.pages << filter_page(site, name, cfg, "date", date,
                                    "#{cfg[:prefix]} · #{date}")
        end
      end
      site.data["category_index"] = index
    end

    private

    # Distinct categories across docs, deduped by slug (first label wins), sorted.
    def distinct_categories(docs)
      by_slug = {}
      docs.each do |doc|
        Array(doc.data["categories"]).each do |c|
          label = c.to_s.strip
          next if label.empty?
          by_slug[Jekyll::Utils.slugify(label)] ||= label
        end
      end
      by_slug.map { |slug, label| { "slug" => slug, "label" => label } }
             .sort_by { |c| c["label"].downcase }
    end

    def slug_of(doc)
      doc.data["slug"] || doc.url.split("/").reject(&:empty?).last
    end

    def date_of(doc)
      # Jekyll parses & validates `date` on read (failing the build on an
      # unparseable value), so data["date"] is always a Time or nil here.
      d = doc.data["date"]
      d.respond_to?(:strftime) ? d.strftime("%Y-%m-%d") : nil
    end

    def filter_page(site, coll_name, cfg, type, value, title)
      page = Jekyll::PageWithoutAFile.new(site, site.source,
                                          File.join(cfg[:base], value), "index.html")
      page.data.merge!(
        "layout"          => "list",
        "title"           => title,
        "collection_name" => coll_name,
        "filter_type"     => type,
        "filter_value"    => value,
      )
      page
    end

    def validate_heroes!(coll_name, docs)
      require_field!(coll_name, docs, "hero") { |d| d.data["hero"].to_s.strip.empty? }
    end

    def validate_dates!(coll_name, docs)
      require_field!(coll_name, docs, "date") { |d| !d.data["date"].respond_to?(:strftime) }
    end

    # Fail the build if any doc is "missing" the field per the given predicate.
    def require_field!(coll_name, docs, field)
      missing = docs.select { |d| yield d }
      return if missing.empty?
      paths = missing.map(&:relative_path).join(", ")
      raise "axy archives: #{coll_name} item(s) missing required `#{field}`: #{paths}"
    end

    def validate_collisions!(coll_name, slugs, categories, dates)
      clash = slugs & (categories + dates)
      unless clash.empty?
        raise "axy archives: in `#{coll_name}`, item slug(s) collide with a " \
              "category/date filter under the same path: #{clash.join(', ')}. " \
              "Rename the item, the category, or change the date."
      end
      dup = categories & dates
      return if dup.empty?
      raise "axy archives: in `#{coll_name}`, category name(s) collide with a " \
            "date: #{dup.join(', ')}."
    end
  end
end
