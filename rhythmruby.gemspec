# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rhythmruby/version'

Gem::Specification.new do |gem|
  gem.name          = "rhythmruby"
  gem.version       = Rhythmruby::VERSION
  gem.authors       = ["Luuk van der Velden"]
  gem.email         = ["l.j.j.vandervelden@gmail.com"]
  gem.description   = %q{create midi rhythm files, using a binary symbol String abstraction as the interface}
  gem.summary       = %q{allows manipulation, parsing and writing to midi of binary rhythm strings, this rhythm abstraction was build on top of the midilib gem by Jim Menard, thanks Jim!}
  gem.homepage      = "https://github.com/Lvelden/rhythmruby"

  gem.files         = `git ls-files`.split($/)
  puts gem.files
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'midilib'
end
