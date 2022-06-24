# coding: utf-8
require_relative 'lib/calendarium-romanum/historical/version'

Gem::Specification.new do |spec|
  spec.name          = "calendarium-romanum-historical"
  spec.version       = Calendarium::Romanum::Historical::VERSION
  spec.authors       = ['Jakub Pavlík']
  spec.email         = ['jkb.pavlik@gmail.com']

  spec.summary       = 'historically accurate Roman Catholic liturgical calendar computations'
  spec.description   = <<~EOS
  Builds upon the calendarium-romanum gem (i.e. deals only with the post-Vatican II liturgical
  calendar) and provides additional capabilities for dealing with not only a single state of the calendar,
  but also it's development in time.
  EOS
  spec.homepage      = 'https://github.com/calendarium-romanum/historical'
  spec.licenses      = ['LGPL-3.0', 'MIT']
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = 'https://github.com/calendarium-romanum/historical'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'calendarium-romanum', '~> 0.9.0'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'thor'
end
