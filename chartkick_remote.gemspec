# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chartkick/remote/version'

Gem::Specification.new do |spec|
  spec.name          = "chartkick-remote"
  spec.version       = Chartkick::Remote::VERSION
  spec.authors       = ["Andrew S. Brown"]
  spec.email         = ["andrew@dontfidget.com"]
  spec.description   = %q{Automatically generate remote json for chartkick}
  spec.summary       = %q{Automatically generate remote json for chartkick}
  spec.homepage      = "https://github.com/dontfidget/chartkick-remote"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 1.9'

  spec.add_development_dependency "bundler", '~> 1.3'
  spec.add_development_dependency "rake", '~> 10.3'
  spec.add_development_dependency "chartkick", '~> 1.2'
  spec.add_development_dependency "activesupport", '~> 4.1'
  spec.add_development_dependency "rspec", '~> 3.0'
  spec.add_development_dependency "rspec-rails", '~> 3.0'
  spec.add_development_dependency "pry", '>= 0'
  spec.add_development_dependency "pry-doc", '>= 0'
  spec.add_development_dependency "travis-lint", '>= 1.8'
  spec.add_development_dependency "codeclimate-test-reporter", '>= 0.3'
  spec.add_development_dependency "rspec-html-matchers", '~> 0.6.1'
end
