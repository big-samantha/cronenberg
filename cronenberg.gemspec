# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cronenberg/version'

Gem::Specification.new do |spec|
  spec.name          = "cronenberg"
  spec.version       = Cronenberg::VERSION
  spec.authors       = ["Zee Alexander"]
  spec.email         = ["zee@zee.space"]
  spec.license       = 'Apache-2.0'

  spec.summary       = 'A Ruby vSphere API helper that wraps rbvmomi, aiming to simplify certain basic tasks.'
  spec.homepage      = "https://github.com/pizzaops/cronenberg"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime Dependencies
  spec.add_runtime_dependency 'rbvmomi', ['>= 1.8.2', '< 2.0.0']
  
  # Development Dependencies
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
