source 'https://rubygems.org'
gemspec

if ENV["GH_PAGES"]
  gem "github-pages"
elsif ENV["BUNTO_VERSION"]
  gem "bunto", "~> #{ENV["BUNTO_VERSION"]}"
end
