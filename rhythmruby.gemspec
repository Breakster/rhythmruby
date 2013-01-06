# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rhythmruby/version'

Gem::Specification.new do |gem|
  gem.name          = "rhythmruby"
  gem.version       = Rhythmruby::VERSION
  gem.authors       = ["Luuk van der Velden"]
  gem.email         = ["l.j.j.vandervelden@gmail.com"]
  gem.description   = %q{represent rhythms as symbolic Strings and write them to MIDI}
  gem.summary       = %q{represent rhythms as symbolic Strings and write them to MIDI}
  gem.homepage      = "https://github.com/Lvelden/rhythmruby"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'midilib'
end
