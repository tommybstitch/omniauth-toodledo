# encoding: utf-8

$:.push File.expand_path('../lib', __FILE__)
require 'omniauth-toodledo/version'

Gem::Specification.new do |gem|
  gem.name = 'omniauth-toodledo'
  gem.version = Omniauth::Toodledo::VERSION
  gem.authors = ['alswl']
  gem.email = ['alswlx@gmail.com']
  gem.homepage = 'http://github.com/alswl/omniauth-toodledo'
  gem.summary = 'OmniAuth strategy for toodledo.com'
  gem.description = gem.summary

  gem.rubyforge_project = 'omniauth-toodledo'

  gem.files = `git ls-files`.split('\n')
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split('\n')
  gem.executables = `git ls-files -- bin/*`.split('\n').map{ |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'omniauth-oauth', '~> 1.0'
  gem.add_runtime_dependency 'rest-client', '~> 1.6.7'
  gem.add_runtime_dependency 'multi_json', '~> 1.3.6'
  gem.add_development_dependency 'rspec', '~> 2.7'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'webmock'

  if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby'
    gem.add_runtime_dependency 'jruby-openssl'
  end
end
