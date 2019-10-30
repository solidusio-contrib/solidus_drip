# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)
require 'solidus_drip/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_drip'
  s.version     = SolidusDrip::VERSION
  s.summary     = 'Solidus integration for Drip'
  s.description = 'Solidus integration for Drip'
  s.license     = 'BSD-3-Clause'

  s.author    = 'Eric Saupe'
  s.email     = 'esaupe@deseretbook.com'
  s.homepage  = 'https://solidus.io/'

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'drip-ruby'
  s.add_dependency 'solidus_core' # Set Solidus version

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'gem-release'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
