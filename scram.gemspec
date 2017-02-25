$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "scram/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = "scram"
  s.version       = Scram::VERSION
  s.authors       = ["skreem"]
  s.email         = ["cskreem@gmail.com"]
  s.summary       = "Awesome authorization system"
  s.description   = "Authorization system that utilizes an extremely flexible hierarchy"
  s.homepage      = "http://github.com/skreem/scram"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]
  
  s.add_runtime_dependency 'rails', '~> 5.0', '>= 5.0.1'
  s.add_dependency "mongoid", "~> 6.1"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "coveralls", "~> 0.8.19"
  s.add_development_dependency "factory_girl", "~> 4.8"
  s.add_development_dependency "database_cleaner", "~> 1.5"
end
