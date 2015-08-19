require 'active_support/concern'
require 'doorkeeper_sso_client/mixins'
require "doorkeeper_sso_client/engine"
require 'doorkeeper_sso_client/config'
require 'doorkeeper_sso_client/logging'
require 'doorkeeper_sso_client/warden/support'
require 'doorkeeper_sso_client/version'
require 'omniauth/strategies/doorkeeper_sso'

module DoorkeeperSsoClient
  def self.table_name_prefix
    'sso_client_'
  end
end
