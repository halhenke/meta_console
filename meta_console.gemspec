# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'meta_console/version'

Gem::Specification.new do |spec|
  spec.name          = "meta_console"
  spec.version       = MetaConsole::VERSION
  spec.authors       = ["Hal Henke"]
  spec.email         = ["halhenke@gmail.com"]
  spec.summary       = %q{This does some magic stuff with your Console/REPL, and does some pretty groovy shit with your objects - I want to get introspective.}
  spec.description   = %q{I cant be bothered writing any more for now..}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "awesome_print", "~> 1.6"
  spec.add_dependency "activerecord", "~> 4.0"
  spec.add_dependency "activesupport", "~> 4.0"
  spec.add_dependency "pry", "~> 0.10"
end
