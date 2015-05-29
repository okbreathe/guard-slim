# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "guard/slim/version"

Gem::Specification.new do |spec|
  spec.name          = "guard-slim"
  spec.version       = Guard::Slim::VERSION
  spec.authors       = ["Indrek Juhkam", "Asher Van Brunt"]
  spec.email         = ["indrek@urgas.eu", "asher@okbreathe.com"]
  spec.description   = %q{}
  spec.summary       = %q{Guard gem for slim}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'guard-compat', '~> 1.1'
  spec.add_dependency "slim"
end
