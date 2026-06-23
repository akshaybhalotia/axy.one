# Compiles _tailwind/app.css -> assets/css/main.css using the Tailwind v4
# standalone CLI binary (no Node/npm). The binary is fetched and cached in bin/
# on first run. Runs on every Jekyll (re)build so `jekyll serve` alone is enough.
require "open-uri"
require "digest"
require "fileutils"

module TailwindBuild
  VERSION = "v4.3.1".freeze

  # sha256 of each supported platform binary for VERSION.
  CHECKSUMS = {
    "macos-arm64" => "a27c43626185953ee19bdace1939c7601e55da654e0b2fc4461e3e29957aa739",
    "linux-x64"   => "2526d063ba03b71f9a3ea7d5cee14f0aec147f117f222d5adc97b1d736d45999",
  }.freeze

  module_function

  def platform
    case RbConfig::CONFIG["host_os"]
    when /darwin/ then "macos-arm64"
    when /linux/  then "linux-x64"
    else raise "Tailwind plugin: unsupported platform #{RbConfig::CONFIG['host_os']}"
    end
  end

  def binary_path(site)
    File.join(site.source, "bin", "tailwindcss")
  end

  def ensure_binary(site)
    path = binary_path(site)
    return path if File.executable?(path) && valid?(path)

    plat = platform
    url = "https://github.com/tailwindlabs/tailwindcss/releases/download/" \
          "#{VERSION}/tailwindcss-#{plat}"
    Jekyll.logger.info "Tailwind:", "downloading #{VERSION} (#{plat})"
    FileUtils.mkdir_p(File.dirname(path))
    URI.open(url) { |remote| File.open(path, "wb") { |f| f.write(remote.read) } }
    unless valid?(path)
      raise "Tailwind plugin: checksum mismatch for downloaded binary (#{plat})"
    end
    File.chmod(0o755, path)
    path
  end

  def valid?(path)
    Digest::SHA256.file(path).hexdigest == CHECKSUMS[platform]
  rescue StandardError
    false
  end

  def compile(site)
    bin = ensure_binary(site)
    input = File.join(site.source, "_tailwind", "app.css")
    output = File.join(site.source, "assets", "css", "main.css")
    FileUtils.mkdir_p(File.dirname(output))
    cmd = [bin, "-i", input, "-o", output]
    cmd << "--minify" if Jekyll.env == "production"
    Jekyll.logger.info "Tailwind:", "compiling #{Jekyll.env == 'production' ? '(minified)' : ''}"
    system(*cmd) || raise("Tailwind plugin: compile failed")
  end
end

# Compile before Jekyll reads files so the generated CSS is collected as a static
# file. :after_reset fires on every (re)build, so `jekyll serve` recompiles on
# each change without a separate watcher.
Jekyll::Hooks.register :site, :after_reset do |site|
  TailwindBuild.compile(site)
end
