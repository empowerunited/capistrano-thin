# -*- encoding: utf-8 -*-
require File.expand_path('../lib/capistrano-thin/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["John Bintz", "Gudata"]
  gem.email         = ["john@coswellproductions.com", "i.bardarov@gmail.com"]
  gem.description   = %q{Capistrano helper for managing a thin server}
  gem.summary       = %q{Capistrano helper for managing a thin server}
  gem.homepage      = ""

  gem.files         = %W(
    lib/capistrano-thin.rb
    lib/capistrano-thin/version.rb
  )
  gem.executables   = []
  gem.test_files    = []
  gem.name          = "capistrano-thin"
  gem.require_paths = ["lib"]
  gem.version       = Capistrano::Thin::VERSION

  gem.add_dependency 'capistrano', '>= 2.0.0'
end
