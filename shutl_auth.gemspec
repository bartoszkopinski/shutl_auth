# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shutl_auth/version'

Gem::Specification.new do |gem|
  gem.name          = "shutl_auth"
  gem.version       = Shutl::Auth::VERSION
  gem.authors       = ["Mark Burns"]
  gem.email         = ["markthedeveloper@gmail.com"]
  gem.description   = %q{Library used for using Shutl OAuth2 bearer tokens}
  gem.summary       = %q{Used by various gems/services for communicating with shutl oauth server}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'retriable'
  gem.add_dependency 'rack-oauth2'

  gem.add_development_dependency 'rspec', '~> 2.11.0'
  gem.add_development_dependency 'debugger'
  gem.add_development_dependency 'webmock', '~> 1.8.7'


end
