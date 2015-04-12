# -*- encoding: utf-8 -*-
VERSION = "0.0.2"

Gem::Specification.new do |spec|
  spec.name          = "PackingPeanut"
  spec.version       = VERSION
  spec.authors       = ["Gant"]
  spec.email         = ["GantMan@gmail.com"]
  spec.description   = "App persistent data for RubyMotion Android"
  spec.summary       = "App persistent data for RubyMotion Android, designed to fit the API stylings of the popular iOS Gem BubbleWrap which also supplies persistence."
  spec.homepage      = "http://gantman.github.io/PackingPeanut/"
  spec.license       = "MIT"

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
end
