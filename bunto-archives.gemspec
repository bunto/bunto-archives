lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bunto-archives/version'

Gem::Specification.new do |s|
  s.name        = "bunto-archives"
  s.summary     = "Post archives for Bunto."
  s.description = "Automatically generate post archives by dates, tags, and categories."
  s.version     = Bunto::Archives::VERSION
  s.authors     = ["Alfred Xing", "Suriyaa Kudo"]

  s.homepage    = "https://github.com/bunto/bunto-archives"
  s.licenses    = ["MIT"]
  s.files       = ["lib/bunto-archives.rb", "lib/bunto-archives/archive.rb"]

  s.add_dependency "bunto", '>= 2.0'

  s.add_development_dependency  'rake'
  s.add_development_dependency  'rdoc'
  s.add_development_dependency  'shoulda'
  s.add_development_dependency  'minitest'
end
