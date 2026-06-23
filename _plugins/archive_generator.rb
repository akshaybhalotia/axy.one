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
      COLLECTIONS.each do |name, cfg|
        coll = site.collections[name]
        next if coll.nil? || coll.docs.empty?
        docs = coll.docs

        validate_heroes!(name, docs) if name == "work"
        validate_dates!(name, docs)

        slugs = docs.map { |d| slug_of(d) }
        categories = docs.flat_map { |d| Array(d.data["categories"]) }
                         .map { |c| Jekyll::Utils.slugify(c.to_s) }
                         .reject(&:empty?).uniq
        dates = docs.map { |d| date_of(d) }.compact.uniq

        validate_collisions!(name, slugs, categories, dates)

        categories.each do |cat|
          site.pages << filter_page(site, name, cfg, "category", cat,
                                    "#{cfg[:prefix]} · #{cat}")
        end
        dates.each do |date|
          site.pages << filter_page(site, name, cfg, "date", date,
                                    "#{cfg[:prefix]} · #{date}")
        end
      end
    end

    private

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
      missing = docs.select { |d| d.data["hero"].to_s.strip.empty? }
      return if missing.empty?
      paths = missing.map(&:relative_path).join(", ")
      raise "axy archives: #{coll_name} item(s) missing required `hero`: #{paths}"
    end

    def validate_dates!(coll_name, docs)
      missing = docs.reject { |d| d.data["date"].respond_to?(:strftime) }
      return if missing.empty?
      paths = missing.map(&:relative_path).join(", ")
      raise "axy archives: #{coll_name} item(s) missing required `date`: #{paths}"
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
