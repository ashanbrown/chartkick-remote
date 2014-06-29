# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chartkick_remote/version'

Gem::Specification.new do |spec|
  spec.name          = "chartkick_remote"
  spec.version       = Chartkick::Remote::VERSION
  spec.authors       = ["Andrew Brown"]
  spec.email         = ["andrew@dontfidget.com.com"]
  spec.description   = %q{Automatically generate remote json for chartkick}
  spec.summary       = %q{Automatically generate remote json for chartkick}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "chartkick"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-doc"
end
