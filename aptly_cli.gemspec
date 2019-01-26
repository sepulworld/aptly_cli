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
    spec.metadata['optional_gems']     = "keyring"
  end

  spec.summary               = %q{Command line client to interact with Aptly package management system}
  spec.description           = %q{Aptly API client}
  spec.homepage              = "https://github.com/sepulworld/aptly_cli"
  spec.license               = "MIT"

  spec.files                 = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir                = "bin"
  spec.executables           = "aptly-cli" 
  spec.require_paths         = ["lib"]
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rubocop"

  spec.add_dependency "httmultiparty", "~> 0.3.16"
  spec.add_dependency "httparty", "~> 0.13.0"
  spec.add_dependency "commander", "~> 4.3"
end
