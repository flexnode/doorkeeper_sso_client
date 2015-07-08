require 'mixlib/config'

module DoorkeeperSsoClient
  # Temporary hardcoded config module
  class Config
    extend Mixlib::Config

    config_strict_mode true
    configurable :oauth_client_id
    configurable :oauth_client_secret
    configurable :base_uri
    default :sessions_path, '/sso/sessions'
    default :oauth_login_path, '/auth/doorkeeper_sso'
    default :passport_verification_timeout_ms, 200
  end

end
