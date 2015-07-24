$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "doorkeeper_sso_client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "doorkeeper_sso_client"
  s.version     = DoorkeeperSsoClient::VERSION
  s.authors     = ["John Wong"]
  s.email       = ["john@flexnode.com"]
  s.homepage    = "https://github.com/flexnode/sso_client"
  s.summary     = "Client gem for flexnode/doorkeeper_sso"
  s.description = "Provides SSO auth functionality based on Omniauth"
  s.license     = "MIT"

  s.files       = Dir['lib/**/*'] & `git ls-files -z`.split("\0")
  s.test_files  = Dir['spec/**/*'] & `git ls-files -z`.split("\0")

  s.required_ruby_version = '>= 1.9'

  s.add_dependency 'omniauth', "~> 1"
  s.add_dependency 'mixlib-config', "~> 2.2"
  s.add_dependency "activesupport", "> 3"
  s.add_dependency 'api-auth', '~> 1.3.1'
  s.add_dependency 'rest-client', '~> 1'
  s.add_runtime_dependency "rails", "> 3"
  s.add_runtime_dependency 'omniauth-oauth2'
  s.add_runtime_dependency 'warden', '~> 1'
  s.add_runtime_dependency 'operation', '~> 0.0.3'

  # Development
  s.add_development_dependency 'database_cleaner', '>= 1.4'
  s.add_development_dependency "pg", '~> 0.18'
  s.add_development_dependency "mongoid", '~> 3'
  s.add_development_dependency 'rspec-rails', '>= 3.0'
  s.add_development_dependency 'shoulda-matchers', '>= 2.8'
  s.add_development_dependency 'simplecov', '>= 0.9.0'
  s.add_development_dependency 'timecop', '>= 0.7'
  s.add_development_dependency 'webmock', '>= 1.2'
  s.add_development_dependency 'fabrication', '>= 2.0'
  s.add_development_dependency 'vcr', '>= 2.9'
  s.add_development_dependency 'nyan-cat-formatter', '>= 0.11'
  s.add_development_dependency 'combustion', '~> 0.5.3'
  s.add_development_dependency 'ffaker', '>= 1'
  s.add_development_dependency 'devise', '~> 3.0'
end
