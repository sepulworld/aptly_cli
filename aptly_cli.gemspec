# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aptly_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "aptly_cli"
  spec.version       = AptlyCli::VERSION
  spec.authors       = ["Zane"]
  spec.email         = ["zane.williamson@gmail.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://rubygems.org"
  end

  spec.summary       = %q{Command line client to interact with Aptly package management system}
  spec.homepage      = "http://rubygems.org/gems/aptly_cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "webmock", "~> 1.20.4"
  spec.add_development_dependency "vcr", "~> 2.9.3"
  spec.add_development_dependency "turn", "~> 0.9.7"
  
  spec.add_dependency "httparty", "~> 0.13.3"
end
