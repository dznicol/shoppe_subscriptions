$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'shoppe_subscriptions/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'shoppe_subscriptions'
  s.version     = ShoppeSubscriptions::VERSION
  s.authors     = ['David Nicol']
  s.email       = ['david@sidstan.com']
  s.homepage    = ''
  s.summary     = 'A subscriptions module for use with Shoppe.'
  s.description = 'A subscriptions module for use with Shoppe.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 4.2.8'
  s.add_dependency 'shoppe', '> 0.0.9', '< 2'
  s.add_dependency 'stripe', '~> 2.8.0'
  s.add_dependency 'stripe_event'
end
