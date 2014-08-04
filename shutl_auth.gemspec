# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shutl/auth/version'
$platform ||= RUBY_PLATFORM[/java/] || 'ruby'

Gem::Specification.new do |gem|
  gem.name          = "shutl_auth"
  gem.version       = Shutl::Auth::VERSION
  gem.authors       = ["Mark Burns"]
  gem.email         = ["markthedeveloper@gmail.com"]
  gem.description   = %q{Library used for using Shutl OAuth2 bearer tokens}
  gem.summary       = %q{Used by various gems/services for communicating with shutl oauth server}
  gem.homepage      = ""
  gem.platform       = $platform

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'retriable', '~> 1.3.1'
  gem.add_dependency 'rack-oauth2'
  gem.add_dependency 'crack', '~> 0.3.2'
  gem.add_dependency 'faraday'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 2.11.0'
  gem.add_development_dependency 'debugger'   if $platform.to_s == 'ruby'
  gem.add_development_dependency 'ruby-debug' if $platform.to_s == 'java'
  gem.add_development_dependency 'webmock', '~> 1.8.7'
  gem.add_development_dependency 'vcr'
end
