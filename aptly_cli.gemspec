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
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  end

  spec.summary               = %q{Command line client to interact with Aptly package management system}
  spec.description           = %q{Aptly API client}
  spec.homepage              = "https://github.com/sepulworld/aptly_cli"
  spec.license               = "MIT"

  spec.files                 = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir                = "bin"
  spec.executables           = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths         = ["lib"]
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  
  spec.add_dependency "httmultiparty", "~> 0.3.16"
  spec.add_dependency "commander", "~> 4.3"
end
