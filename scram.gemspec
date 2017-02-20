# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scram/version'

Gem::Specification.new do |spec|
  spec.name          = "scram"
  spec.version       = Scram::VERSION
  spec.authors       = ["skreem"]
  spec.email         = ["cskreem@gmail.com"]

  spec.summary       = "Awesome authorization system"
  spec.description   = "Authorization system that utilizes an extremely flexible hierarchy"
  spec.homepage      = "http://github.com/" # TODO

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end
  spec.metadata["yard.run"] = "yri"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "mongoid", "~> 6.1"
  spec.add_dependency "activesupport", "~> 5.0"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "coveralls", "~> 0.8.19"
  spec.add_development_dependency "factory_girl", "~> 4.8"
  spec.add_development_dependency "database_cleaner", "~> 1.5"
end
