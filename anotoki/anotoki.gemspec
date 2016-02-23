$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "anotoki/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "anotoki"
  s.version     = Anotoki::VERSION
  s.authors     = ["Akihiro Nagashima"]
  s.email       = ["ei.ei.oh.0613@gmail.com"]
  s.summary     = "anotoki no yahoo news"

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "mysql2"
end
