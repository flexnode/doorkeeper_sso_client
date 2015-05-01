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

  s.add_dependency "rails", "> 3"
  s.add_runtime_dependency 'omniauth-oauth2'
  s.add_runtime_dependency 'warden', '~> 1'

  s.add_development_dependency "sqlite3"
end
