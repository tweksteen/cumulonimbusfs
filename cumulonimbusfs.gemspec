# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cumulonimbusfs/version'

Gem::Specification.new do |spec|
  spec.name          = "cumulonimbusfs"
  spec.version       = CumulonimbusFS::VERSION
  spec.authors       = ["Thiébaud Weksteen"]
  spec.email         = ["thiebaud@weksteen.fr"]
  spec.summary       = %q{CumulonimbusFS}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "json", "~> 1.8"
  spec.add_dependency "rfusefs", "~> 1.0"
  spec.add_dependency "lru_redux", "~> 1.1"
  spec.add_dependency "chunky_png", "~> 1.3"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end

