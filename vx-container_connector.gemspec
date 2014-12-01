# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vx/container_connector/version'

Gem::Specification.new do |spec|
  spec.name          = "vx-container_connector"
  spec.version       = Vx::ContainerConnector::VERSION
  spec.authors       = ["Dmitry Galinsky"]
  spec.email         = ["dima.exe@gmail.com"]
  spec.description   = %q{ description }
  spec.summary       = %q{ summary }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'docker-api',   '= 1.15.0'
  spec.add_runtime_dependency 'vx-lib-spawn', '= 0.1.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
